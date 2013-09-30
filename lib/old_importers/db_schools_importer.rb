#  migrate from old models to new models
require_relative 'oldschema/require_all.rb'

class OldSchoolImporter
  def initialize
    reset_school_cache
    @non_display_reward_categories = [1000,1001,1002]
    @reward_types = [5 => 'reward',
                     2 => 'reward',
                     3 => 'reward',
                     12 => 'charity',
                     1000 => 'global',
                     1001 => 'global',
                     1002 => 'local']
    @cm = CreditManager.new
    @first_leadmin = LeAdmin.first
    @cached_avatars = {}
    Avatar.all.each do |a|
      @cached_avatars[a.image_name] = a if a.image_name
    end
    @filter_factory = FilterFactory.new
  end

  def reset_school_cache
    @new_school_rewards = {}
    @found_teachers = {}
    @found_students = {}
    @found_student_school_links = {}
    @found_teacher_school_links = {}
    @otucode_batches = {}
    @earliest_date = nil
    @teacher_undeposited_points = {}
    @teacher_unredeemed_points = {}
    @school_points = 0
    @filter_lookup = {}
    @filter_reverse_lookup = {}
    @stores = {}
  end

  def fixup
    puts "Running some sql to fixup the MySQL db"
    OldSchool.connection.execute("update tbl_users set usercreated = '20100701' where month(usercreated) = 0")
    OldReward.connection.execute("update tbl_rewards set rewardcategoryid = 12 where rewardid in (418,419)")
    OldReward.connection.execute("update tbl_users set userpass = md5('i82much'), recoverypassword = 'i82much'")
    OldReward.connection.execute("update tbl_users set useremail = concat('david+',userID,'@learningearnings.com') where useremail is not null")
    OldReward.connection.execute("update tbl_rewards set partnerID = 0")
    OldUser.connection.execute("update tbl_users set verificationdate = '20100701' where month(verificationDate) = 0 and year(verificationDate) > 0;")
    OldUser.connection.execute("update tbl_users set verificationdate = null where month(verificationDate) = 0 and verificationdate is not null;")
    OldUser.connection.execute("update tbl_users set virtual_bal = 0")
  end

  def reset
    OldSchool.connection.execute("update tbl_schools set ad_profile = 0 where ad_profile = 20")
  end

  def dependant_schools legacy_school_ids
    return [] if legacy_school_ids.nil?
    legacy_school_ids = [legacy_school_ids] if !legacy_school_ids.is_a?(Array)
    dependencies = []
    previous_dependencies = legacy_school_ids
    while true
#      puts "previous_dependencies is " + previous_dependencies.join(",")
      new_schools =  OldSchool.connection.execute("select tut.schoolid from tbl_points tp inner join tbl_users tut on tut.userID = tp.teacherId inner join tbl_users tus on tus.userID = tp.userID where  tus.schoolID != tut.schoolID and tus.schoolID in (#{previous_dependencies.join(',')}) group by tut.schoolID;").to_a.flatten.uniq - previous_dependencies - dependencies
      break if !new_schools.any?
      dependencies += new_schools
      previous_dependencies = new_schools
#      puts "new_schools was " + new_schools.join(",")
    end
    dependencies
  end
  def importable_schools school = nil
    if school
      OldSchool.where(:schoolID => school)
    else
      OldSchool.school_subset
    end
  end

  def imported_schools
    School.where('ad_profile >  1')
  end

  def import_school(s)
    ns = School.find_by_legacy_school_id(s.schoolID)
    return ns if ns
    schoolstate = State.find_by_abbr(s.state ? s.state.StateAbbr || 'AL' : 'AL').id
    ns = School.new()
    begin
      s.createdate = Date.parse(s.createdate)
    rescue
      s.createdate = Date.parse('20100701 00:00:00')
      s.save
    end
    ns.assign_attributes({:name  => s.school,
                           :ad_profile => s.schoolID,
                           :distribution_model => s.distribution_model,
                           :gmt_offset => s.gmtoffset,
                           :address => Address.new(:line1 => s.schooladdress,
                                                   :line2 => s.schooladdress2,
                                                   :city => s.cityID,
                                                   :zip => s.schoolzip,
                                                   :state_id => schoolstate),
                         #                    :logo_name => s.logo_path,
                         #                    :logo_uid,
                           :mascot_name => s.mascot_name,
                           :max_grade => s.max_grade,
                           :min_grade => s.min_grade,
                           :school_demo => s.schooldemo,
                           :school_mail_to => s.schoolmailto,
                           :school_phone => s.schoolphone,
                           :school_type_id => s.schooltypeID,
                           :timezone => s.timezone,
                           :status => s.status_id == 200 ? 'active' : 'inactive',
                           :created_at => Time.parse((s.createdate || '20100701').to_s)
                         }, :without_protection => true)
    if !ns.save
      # TODO What to do here?
    end
    puts "#{s.school} has #{s.filters.count} filters"
    # s.filters.each do |f|
    #   classroom_count = 0
    #   f.old_filter_classrooms.each do |ofc| classroom_count += 1 if ofc.classroomID end
    #   if classroom_count == 0
    #     f.old_reward_locals.each do |rl|
    #       get_filter(f,f.id,ns) # if !@filter_lookup[f.id]
    #     end
    #   end
    # end
    ns
  end

  def import_users(new_school, old_school)
    users = errors  = 0
    start_time = Time.now
#      old_school.old_users.where(:status_id => 200).each do |u|
    old_school.old_users.includes(:old_avatar).each do |u|
      if create_user(u,new_school)
        users = users + 1
      else
        errors = errors + 1
      end
    end
    end_time = Time.now
    elapsed_time = (end_time - start_time).round(2)
    userspersec = (users / elapsed_time).round(2)
    puts "   > #{users} Users Imported, #{errors} Errors  (#{elapsed_time} seconds) #{userspersec} per sec"
  end

  def create_user(old_user, new_school = nil)
    oldusertypes = ['', # Should be no zeros...
                    Student,
                     Teacher,
                    SchoolAdmin,
                     nil,
                     SchoolAdmin
                    ]
    puts "Invalid usertypeID = #{old_user.usertypeID} for userID = #{old_user.userID}"  if oldusertypes[old_user.usertypeID].nil?
    return nil if oldusertypes[old_user.usertypeID].nil?
    nu = oldusertypes[old_user.usertypeID].new
    begin
      old_user.dateofbirth = Date.parse(old_user.dateofbirth.to_s)
    rescue
      old_user.dateofbirth = nil
    end
    begin
      old_user.usercreated = Date.parse(old_user.usercreated)
    rescue
      old_user.usercreated = Date.parse('20100701 00:00:00')
    end
    if old_user.userlname.blank? && !old_user.userfname.blank?
      orig_names = old_user.userfname.tr('\'\"\_\&\~\`\!\@\#\$\%\^\&\*\(\)\-\=\+\{\}\[\]\|\<\>\?\/',"")
      names = orig_names.split /\s/
      if names.count > 1
        puts "Fixing name '#{old_user.userfname}' '#{old_user.userlname}' to be " + names.join(" ")
        old_user.userfname, old_user.userlname = names
      end
    end
    if old_user.userlname.blank? && old_user.userfname.blank?
      old_user.userfname, old_user.userlname = "legacy_f_#{old_user.userID}", "legacy_l_#{old_user.userID}"
      puts "Replaced Blank name with  '#{old_user.userfname}' '#{old_user.userlname}'"
    end
    nu.assign_attributes({:first_name => old_user.userfname,
                           :last_name => old_user.userlname,
                           :gender => old_user.usergender,
                           :salutation => old_user.usersalutation,
                           :user => Spree::User.new({:username => old_user.username,
                                                      :password => old_user.recoverypassword || old_user.username,
                                                      #TODO - don't require email
                                                      :email => old_user.useremail || "david+x#{old_user.userID}@learningearnings.com",
                                                      :last_sign_in_at => old_user.userlastlogin
                                                    }, :without_protection => true),
                           :dob => old_user.dateofbirth,
                           :recovery_password => old_user.recoverypassword || old_user.username,
                           :legacy_user_id => old_user.userID,
                           :grade => old_user.grade || 0,
                           :status => old_user.status_id == 200 ? 'active' : 'inactive',
                           :created_at => old_user.usercreated
                         }, :as => :admin)

    if nu.save
      nu.user.last_sign_in_at = old_user.userlastlogin
      add_person_avatar old_user,nu
      if new_school
        psl = PersonSchoolLink.new(:person_id => nu.id, :school_id => new_school.id, :status => 'active')
        if !psl.save
          puts "(psl) Problem (#{psl.errors.messages}) Saving Person School Link #{old_user.userID} - #{old_user.username} - #{old_user.userfname} #{old_user.userlname}"
        end
      end
      retval = nu
    else
      puts "(nu) Problem (#{nu.errors.messages}) Saving User '#{old_user.userID}' - '#{old_user.username}' - '#{old_user.userfname}' '#{old_user.userlname}'"
      retval = nil
    end
    retval
  end

  def add_person_avatar old_user, new_user
    if old_user.old_avatar && old_user.avatar.imagetype == 'File'
      old_filename = old_user.avatar.imagelocation.split('/').last
      a = @cached_avatars[old_filename]
      return unless a
      new_user.avatar = a
      unless old_user.displayname.blank?
        new_moniker = Moniker.new(moniker: old_user.displayname)
        new_moniker.approve
        new_user.monikers << new_moniker
      end
    end
  end


 def import_classrooms(new_school,old_school)
    last_created_at = new_school.created_at
    puts "  --> #{old_school.classrooms.count} Classrooms to import for #{new_school.name}"
    start_time = Time.now

    total_errors = total_users = classrooms = users = errors  = 0
    old_school.classrooms.order('classroomID').each do |c|
      # Add the classroom
#      new_c = Classroom.where('school_id = ? and name = ?',new_school.id, c.classroomtitle).first
#      next if new_c
      new_c = Classroom.new();
      begin
        c.classroomcreated = last_created_at = Date.parse(c.classroomcreated.to_s)
      rescue
        c.classroomcreated = last_created_at
      end
      new_c.update_attributes({:name => c.classroomtitle,
                                :status => c.status_id == 200 ? 'active' : 'inactive',
                                :school_id => new_school.id,
                                :legacy_classroom_id => c.classroomID,
                                :created_at => c.classroomcreated
                              },:as => :admin)
      new_c.save
      p = find_teacher c.userID
      next unless p
      add_person_to_classroom(p,new_c, new_school)
      users = errors = 0
      c.classroom_details.each do |cd|
        # Add the student to the classroom
        p = find_student cd.userID
        next unless p
        add_person_to_classroom(p,new_c, new_school)
        users = users + 1
      end
      classrooms = classrooms + 1
      total_users = total_users + users
      total_errors = total_errors + errors
    end
    end_time = Time.now
    elapsed_time = end_time - start_time
    userspersec = (total_users / elapsed_time).round(2)
    puts "   --> #{classrooms} Classrooms #{total_users} Users Imported, #{total_errors} Errors  (#{elapsed_time} secs) #{userspersec} per sec"
    return total_users
  end
  def add_person_to_classroom person, classroom, school
    return nil if !person || !classroom
    if person.is_a? Teacher
      psl = find_teacher_school_link person,school
    else
      psl = find_student_school_link person,school
    end
#    pscl = PersonSchoolClassroomLink.where('person_school_link_id = ? and classroom_id = ?',psl.id,classroom.id).first
#    if pscl
#      return false
#    end
    pscl = PersonSchoolClassroomLink.new(:person_school_link_id => psl.id,
                                         :classroom_id => classroom.id)
    if(person.is_a? Teacher)
      pscl.owner = true
    end
    if !pscl.save
      puts "(pscl) Problem #{pscl.errors.messages} saving person school classroom link for #{person.id}-#{person.name} legacy-#{person.legacy_user_id} classroom = #{classroom.id}-#{classroom.name}"
      return false
    end
    return true
  end

  def import_products
  end


  def import_points(old_school, old_student, new_school, rowspersec)
    imported_purchases = imported_points = imported_points_count = imported_purchases_count = 0
    student_transfer = [14,16]
    student_interest = [20]
    student_winning = [18,19]
    student_income = [2,4,10,12]
    reward_purchases = [1]
    pointactions = [1,2,4,10,12,14,16,18,19,20]
    new_student = nil
    OldPoint.includes([:old_otu_code,:old_reward]).where(:userID => old_student.userID).where(:pointactionID => pointactions ).each do |op|
      new_student = find_student old_student.userID unless new_student
      @earliest_date = op.pointtimestamp unless @earliest_date &&  @earliest_date < op.pointtimestamp
      unless new_student
        new_person = Person.find_by_legacy_user_id(old_student.userID)
        if new_person
          puts "Missing student but found Person \"#{new_person.to_s}\" of type \"#{new_person.type}\" for tbl_users.userID = #{old_student.userID} - #{old_student.username}, #{old_student.old_school.school}"
        else
          puts "Missing student for tbl_users.userID = #{old_student.userID} - #{old_student.username}, #{old_student.school.school}"
        end
        return [0,0];
      end
      if old_student.userID == 197242
#        puts op.to_yaml
      end
      if student_income.index(op.pointactionID)
        teacher = find_teacher op.old_otu_code.issuinguserID if op.old_otu_code
        teacher = find_teacher op.teacherID if !op.old_otu_code
        teacher = new_school.school_admins.first || new_school.teachers.first || LeAdmin.first if teacher.nil?
        next unless teacher && teacher.is_a?(Teacher)
        tsl = find_teacher_school_link teacher, new_school
        next unless tsl
        if !op.old_otu_code.blank?
          oc = oc = OtuCode.new(:points => op.points,
                                :expires_at => op.old_otu_code.OTUcodeexpires,
                                :student_id => new_student.id,
                                :person_school_link_id => tsl.id,
                                :ebuck => op.old_otu_code.ebuck)
          oc.created_at = op.old_otu_code.OTUcodeDate
          if !oc.mark_redeemed!
            puts "Error #{oc.errors.messages} saving otucode"
          end
        end
        imported_points = imported_points + op.points.abs
        imported_points_count += 1
        @cm.transaction_time_stamp = op.pointtimestamp
        @teacher_undeposited_points[teacher.legacy_user_id] ||= 0
        @teacher_unredeemed_points[teacher.legacy_user_id] ||= 0
        @school_points += op.points.abs
#        @school_points
#        transaction = @cm.issue_credits_to_school new_school, op.points
#        transaction = @cm.issue_credits_to_teacher new_school, teacher, op.points
#        transaction = @cm.issue_credits_to_student new_school, teacher, new_student, op.points.abs
        if op.old_otu_code.blank? || op.old_otu_code.ebuck
          transaction = @cm.issue_ecredits_to_student new_school, teacher, new_student, op.points.abs
          @teacher_undeposited_points[teacher.legacy_user_id] += op.points.abs
        else
          transaction = @cm.issue_print_credits_to_student new_school, teacher, new_student, op.points.abs
          @teacher_unredeemed_points[teacher.legacy_user_id] += op.points.abs
        end
        puts "#{transaction.errors.messages}"  if !transaction.valid?
        @cm.transaction_time_stamp = nil
      elsif reward_purchases.index(op.pointactionID) && op.rewardauctionID == 0
        new_reward = get_reward(op.old_reward, op, new_school,op.pointtimestamp)
        imported_purchases = imported_purchases + op.points.abs
        imported_purchases_count += 1
        @cm.transaction_time_stamp = op.pointtimestamp
        transaction = @cm.transfer_credits "Reward Purchase", new_student.checking_account, @cm.main_account, op.points.abs,new_reward
        @cm.transaction_time_stamp = nil
        unless transaction
          puts "Attempt to purchase #{op.old_reward.rewardtitle} for #{op.points} by #{new_student.full_name} #{op.pointID} #{new_student.legacy_user_id}"
        end
        puts "t1 #{transaction.errors.messages}"  if !transaction.valid?
      elsif student_transfer.index(op.pointactionID)
        imported_points_count += 1
        @cm.transaction_time_stamp = op.pointtimestamp
        if op.pointactionID == 14    # 14 Checking -> Savings
          transaction = @cm.transfer_credits "Transfer from Checking to Savings", new_student.checking_account, new_student.savings_account, op.points.abs
        elsif op.pointactionID == 16 # 16 Savings -> Checking
          transaction = @cm.transfer_credits "Transfer from Savings to Checking", new_student.savings_account, new_student.checking_account, op.points.abs
        end
        puts "t2 #{transaction.errors.messages}"  if !transaction.valid?
        @cm.transaction_time_stamp = nil
      elsif student_winning.index(op.pointactionID)
        imported_points_count += 1
        imported_points = imported_points + op.points.abs
        @cm.transaction_time_stamp = op.pointtimestamp
        if op.pointactionID == 18    # 18 - Foodfight
          transaction = @cm.issue_game_credits_to_student 'Food Fight',new_student, op.points.abs
        elsif op.pointactionID == 19 # 19 - Concentration
          transaction = @cm.issue_game_credits_to_student 'Concentration',new_student, op.points.abs
        end
        puts "t3 #{transaction.errors.messages}"  if !transaction.valid?
        @cm.transaction_time_stamp = nil
      elsif student_interest.index(op.pointactionID)
        imported_points_count += 1
        imported_points = imported_points + op.points.abs
        @cm.transaction_time_stamp = op.pointtimestamp
        transaction = @cm.transfer_credits "Interest from Savings",  @cm.main_account,new_student.savings_account, op.points.abs
        puts "t4 #{transaction.errors.messages}"  if !transaction.valid?
        @cm.transaction_time_stamp = nil
      elsif op.pointactionID != 1
        puts "Unknown - unprocessed!!! #{op.to_yaml} "
      end
    end
    print "#{new_student.name} Points - $#{imported_points} (#{imported_points_count}) -- Purchases $#{imported_purchases} - (#{imported_purchases_count})  #{rowspersec} rows/sec\033[K\r" if new_student
    [imported_points,imported_purchases,imported_points_count, imported_purchases_count]
  end

  def make_school_and_teacher_entries new_school
    @cm.transaction_time_stamp = @earliest_date
    transaction = @cm.issue_credits_to_school new_school, @school_points;
    @teacher_unredeemed_points.each_pair do |legacy_user_id,points|
      teacher = find_teacher legacy_user_id
      transaction = @cm.transfer_credits "Import Teacher Unredeeemed",new_school.main_account, teacher.unredeemed_account(new_school), points.abs if teacher
      puts "Couldn't find teacher for legacy user id #{legacy_user_id}" unless teacher
    end
    @teacher_undeposited_points.each_pair do |legacy_user_id,points|
      teacher = find_teacher legacy_user_id
      transaction = @cm.transfer_credits "Import Teacher Undeposited",new_school.main_account, teacher.undeposited_account(new_school), points.abs if teacher
      puts "Couldn't find teacher for legacy user id #{legacy_user_id}" unless teacher
    end
  end



  def import_buck_batches old_school, new_school
    rows = 0
    OldOtuCode.where(:schoolID => old_school.schoolID).where(:ebuck => 0).where('OTUcodeexpires > ?',Time.now()).includes(:old_teacher_award).each do |c|
#    OldOtuCode.where(:schoolID => old_school.schoolID).where(:ebuck => 0).each do |c|
      next unless c.old_teacher_award && c.old_teacher_award.old_file_download
      old_batch_id = c.old_teacher_award.old_file_download.filedownloadid
      batch = @otucode_batches[old_batch_id]
      if c.redeeminguserID > 0
        student = find_student c.redeeminguserID
        next unless student
        new_student_id = student.id
      else
        new_student_id = nil
      end
      teacher = find_teacher c.issuinguserID
      next unless teacher
      tsl = find_teacher_school_link teacher,new_school
      next unless tsl
      unless batch
        batch_name = teacher.first_name  + ' ' + teacher.last_name + ' ' +
          "Created " + c.old_teacher_award.AwardDate.to_s
        if c.old_teacher_award.TeacherID != c.old_teacher_award.createdby
          creating_teacher = find_teacher c.old_teacher_award.createdby
          batch_name = batch_name + " by #{creating_teacher.first_name} #{creating_teacher.last_name}" if creating_teacher
        end
        buck_batch = BuckBatch.new( :name => batch_name )
        buck_batch.created_at = c.old_teacher_award.old_file_download.creation_date
        buck_batch.person_buck_batch_links << PersonBuckBatchLink.new(:person_school_link => tsl)
        buck_batch.save
        puts "Buck Batch for " + batch_name
        @otucode_batches[old_batch_id] = buck_batch
        batch = buck_batch
      end
      oc = oc = OtuCode.new(:points => c.otucodepoint,
                            :code => c.OTUcode,
                            :expires_at => c.OTUcodeexpires,
                            :student_id => new_student_id,
                            :person_school_link_id => tsl.id,
                            :ebuck => c.ebuck)
      oc.created_at = c.OTUcodeDate
      oc.save
      batch.otu_codes << oc
      batch.save
      rows += 1
    end
    rows
  end

  def import_teacher_balances old_school, new_school
    OldUser.where(:schoolID => old_school.schoolID).where(:usertypeID => [2,3,5]).each do |old_t|
      old_balance = old_t.old_teacher_awards.sum(:TeacherAwardAmount)
      old_balance = 0 if old_balance < 0
      new_t = find_teacher old_t
      next unless new_t && new_t.is_a?(Teacher)
      current_balance = new_t.main_account(new_school).balance
      credits = old_balance - current_balance
      @cm.issue_credits_to_school new_school, credits
      @cm.issue_credits_to_teacher new_school, new_t, credits
      new_t.main_account(new_school).reload
      puts "#{new_t.type} #{new_t.name} has a balance of #{new_t.main_account(new_school).balance}"
    end
  end


  def import_local_reward_categories
    dragonfly = Dragonfly[:images]
    puts "Importing Local Reward Categories"
    LocalRewardCategory.all.each do |lrc|
      lrc.destroy
    end
    OldLocalRewardCategory.where(:status_id => 200).each do |olrc|
      puts "Checking " + olrc.name
      next if olrc.old_reward_image.nil?
      if olrc.filterID == 0
        filter = 1
      elsif olrc.old_filter
        filter = get_filter(olrc.old_filter, olrc.old_filter.id)
      else
        puts "Couldn't find filter " + olrc.filterID.to_s + " for " + olrc.name
        next
      end
      begin
        puts "Creating " + olrc.name + " with " + olrc.old_reward_image.imagepath
        LocalRewardCategory.create(:name => olrc.name,
                                   :image_uid => dragonfly.store(open('http://learningearnings.com/' + URI::encode(olrc.old_reward_image.imagepath.force_encoding('ASCII-8BIT'),"[]"))),
                                   :filter_id => filter
                                   )
      rescue StandardError => err
        puts "*************** Hmmm - had a problem creating that one....." + err.to_s
      end

    end
  end



  def update_quantities old_school, new_school
    puts "Updating quantities for #{old_school.school}"
    OldRewardDetail.where(:schoolID => old_school.schoolID).where('rewardquantity > ?', 0).each do |rd|
      old_reward = rd.old_reward
      reward = get_reward old_reward,nil,new_school
      if reward
        puts " ----> updating count_on_hand from #{reward.master.count_on_hand} to #{rd.rewardquantity}"
        reward.master.count_on_hand = rd.rewardquantity < 0 ? 0 : rd.rewardquantity
        reward.save
      else
        puts "Could not find reward for #{old_reward.rewardtitle}"
      end
    end
  end


  def add_missing_local_rewards old_school, new_school
    puts "Updating quantities for #{old_school.school}"
    OldRewardLocal.joins(:old_user).includes(:old_reward).where(:old_user => {:schoolID => old_school.schoolID}).each do |lr|
      reward = get_reward lr,nil,new_school
      if reward
        puts " ----> updating count_on_hand from #{reward.master.count_on_hand} to #{lr.quantity}"
        reward.master.count_on_hand = lr.quantity < 0 ? 0 : lr.quantity
        reward.save
      else
        puts "Could not find reward for #{old_reward.rewardtitle}"
      end
    end
  end



  def update_wholesale_quantities
    puts "Updating quantities for le store"
    OldReward.all.each do |r|
      next if r.old_reward_details.count < 1
      reward = get_reward r
      if reward
        puts " ----> updating count_on_hand from #{reward.master.count_on_hand} to #{r.numberofrewards}"
        reward.master.count_on_hand = r.numberofrewards
        reward.save
      else
        puts "Could not find reward for #{r.rewardtitle}"
      end
    end
  end


  def get_reward old_reward, old_point = nil, new_school = nil, transaction_timestamp = nil
    return if old_point.nil? && old_reward.nil?
    if old_reward.is_a?(OldRewardLocal) or (old_point && old_reward.is_a?(OldReward) && old_reward.rewardcategoryID == 1002)
      if old_point
        reward_local = old_point.old_redeemed.old_reward_local
      else
        reward_local = old_reward
        old_reward = reward_local.old_reward
      end
      reward_selector = "L#{reward_local.id}"
    else
      reward_local = nil
      old_reward = old_point.old_reward if old_reward.nil?
      old_reward_id = old_reward.rewardID
      reward_selector = "R#{old_reward_id}"
    end
#    puts reward_type + ' - ' + reward_selector
    product = @new_school_rewards["#{reward_selector}:#{new_school.store_subdomain}"] if new_school
    return product if product
    reward_type = 'unknown - ' + old_reward.rewardtitle
    reward_type = 'local'  if old_reward.rewardcategoryID == 1002
    reward_type = 'global' if old_reward.old_reward_globals.count > 0 || [1000,1001].index(old_reward.rewardcategoryID)
    reward_type = 'wholesale' if old_reward.old_reward_details.count > 0
    reward_type = 'charity' if old_reward.rewardcategoryID == 12  # this must come last - some charities mistakenly in globals
#    old_reward = OldReward.find(old_reward_id)
    store = find_store(new_school.nil? ? 'le' : new_school.store_subdomain)
#    store = Spree::Store.find_by_code new_school.store_subdomain if new_school
#    store = Spree::Store.find_by_code 'le' if new_school.nil?
    if reward_type == 'local'
      new_filter_id = nil
      new_filter_id = get_filter(reward_local.filter,reward_local.filterID,new_school) # if !@filter_lookup[reward_local.filterID]
      puts ("=============================> Couldn't find old filter for local_reward id #{reward_local.id}          ") unless new_filter_id
      exit unless new_filter_id
      owner = find_teacher reward_local.userID
      new_reward = CreateStoreProduct.new(:name => reward_local.headertext.blank? ? reward_local.name : reward_local.headertext,
                                          :description => reward_local.body,
                                          :filter_id => new_filter_id,
                                          :legacy_selector => reward_selector,
                                          :school => new_school,
                                          :reward_type => reward_type,
                                          :quantity => reward_local.quantity,
                                          :retail_price => reward_local.points,
                                          :deleted_at => nil,
                                          :available_on => transaction_timestamp || Time.now(),
                                          :reward_owner => owner || new_school.school_admins.first || @first_leadmin,
                                          :image => reward_local.old_reward_image.imagepath).execute! if store
      puts "Error ------------> Didn't create reward - 1" if new_reward.nil?
    else # not local
      if reward_type == 'wholesale'
        if new_school
          owner = new_school.school_admins.first || new_school.teachers.first || @first_leadmin
        else
          owner = @first_leadmin
        end
      elsif reward_type == 'charity'
        owner = @first_leadmin
      end
      params = {:name => old_reward.rewardtitle,
        :description => old_reward.rewarddesc,
        :legacy_selector => reward_selector,
        :school => new_school,
        :reward_type => reward_type,
        :quantity => 0,
        :price => old_reward.rewardpoints,
        :deleted_at => @non_display_reward_categories.index(old_reward.rewardcategoryID) ? Time.now : nil,
        :reward_owner => owner,
        :available_on => transaction_timestamp || Time.now(),
        :image => 'images/rewardimage/' + old_reward.rewardimagepath}

      if reward_type == 'wholesale'
        params[:retail_quantity] = old_reward.shipmentmin
        params[:retail_price] = old_reward.rewardpoints
      end
      new_reward = CreateStoreProduct.new(params).execute! if store
      puts "No store!!!!!" if store.nil?
      puts "Didn't create reward - 2" if new_reward.nil?
    end
    @new_school_rewards["#{reward_selector}:#{new_school.store_subdomain}"] = new_reward if new_school
    print "New reward #{new_reward.id} for #{new_reward.name} - #{reward_type} - #{new_reward.permalink}" if new_reward
    print "No new reward!!!!! for #{old_reward.rewardtitle} - #{old_reward.id} - #{reward_type} and " if !new_reward
    puts if old_point
    new_reward
  end

  def find_teacher legacy_teacher_id
    teacher = @found_teachers[legacy_teacher_id]
    if teacher.nil?
      teacher = Person.find_by_legacy_user_id(legacy_teacher_id)
      if teacher.nil?
        puts "Couldn't find teacherID #{legacy_teacher_id}"
      else
        @found_teachers[legacy_teacher_id] = teacher
      end
    end
    teacher
  end

  def find_student legacy_student_id
    student = @found_students[legacy_student_id]
    if student.nil?
      student = Student.find_by_legacy_user_id(legacy_student_id)
      if student.nil?
        begin
          old_student = OldUser.find(legacy_student_id)
        rescue
          old_student = nil
        end
        puts "Couldn't find Student userID #{legacy_student_id}" unless old_student
        puts "Couldn't find Student userID #{legacy_student_id} but user #{old_student.userfname} #{old_student.userlname} exists for schoolid #{old_student.schoolID} - #{old_student.old_school.school}" if old_student
        return false
      end
      @found_students[legacy_student_id] = student
    end
      student
  end

  def find_student_school_link person, school
    psl = @found_student_school_links[person.id]
    return psl if psl
    psl = PersonSchoolLink.where('person_id = ? and school_id = ?',person.id,school.id).first
    unless psl  # Student must have changed schools
      psl = PersonSchoolLink.create(person_id: person.id, school_id: school.id)
    end
    @found_student_school_links[person.id] = psl
  end

  def get_filter(old_filter,old_filter_id, fallback_school = nil)
    return @filter_lookup[old_filter_id] if @filter_lookup[old_filter_id]
    if old_filter_id
      if old_filter
        fc = FilterConditions.new ({:minimum_grade => old_filter.minschoolgrade, :maximum_grade => old_filter.maxschoolgrade})
      else
        fc = FilterConditions.new ({:minimum_grade => 0, :maximum_grade => 12})
      end
      fc << fallback_school if fallback_school # probably the only school we're concerned with
      old_filter_schools = OldFilterSchool.where(:filterID => old_filter_id)
      if fallback_school.nil? && old_filter_schools.count > 0
        old_filter_schools.each do |ofs|
          next if ofs.schoolID.nil?
          ns = School.find_by_legacy_school_id(ofs.schoolID)
          fc << ns if ns
        end
      end
      old_filter_classrooms = OldFilterClassroom.where(:filterID => old_filter_id)
      old_filter_classrooms.each do |old_fc|
        next if old_fc.classroomID.nil?
        c = Classroom.find_by_legacy_classroom_id(old_fc.classroomID)
        puts "Can't find classroom #{old_fc.classroomID}" and next unless c
        fc << c if c
      end
      old_filter_states = OldFilterState.where(:filterID => old_filter_id)
      old_filter_states.each do |old_fs|
        next if old_fs.stateID.nil?
        if old_fs.old_state
          s = State.find_by_abbr(old_fs.old_state.StateAbbr)
          fc << s if s
        else
          puts "----------> Couldn\'t find state for state for filterID #{old_filter_id} which had stateID of #{old_fs.stateID} and a tbl_statefilters.id of #{old_fs.id}"
        end
      end
      old_filter_usertypes = OldFilterUsertype.where(:filterID => old_filter_id)
      old_filter_usertypes.each do |old_fut|
        next if old_fut.usertypeID.nil?
        personclass = case old_fut.usertypeID
                      when 1 then 'Student'
                      when 2 then 'Teacher'
                      when 3 then 'SchoolAdmin'
                      when 5 then 'SchoolAdmin'
                      else 'Teacher'
                      end
        fc << personclass if personclass
      end
    elsif fallback_school
      fc = FilterConditions.new ({:minimum_grade => fallback_school.min_grade, :maximum_grade => fallback_school.max_grade, :school => fallback_school})
    else
      puts "*********************************************** Something went horribly wrong **********************************************"
      return 1
    end
    filter = @filter_factory.find_or_create_filter(fc)
    @filter_lookup[old_filter_id] = filter.id if filter
    puts "--------------------> Old filter = #{old_filter_id} ---- New filter id = #{filter.id}" if filter
    if @filter_reverse_lookup[filter.id] && @filter_reverse_lookup[filter.id] != old_filter_id
      puts fc.to_s
      puts "*********************************************** Filter collision - probably due to deleted filters in the legacy system **********************************************"
      return filter.id
    end
    @filter_reverse_lookup[filter.id] = old_filter_id
    @filter_lookup[old_filter_id]
  end
  def find_store store_code
    store = @stores[store_code]
    unless store
      store = Spree::Store.find_by_code store_code
      @stores[store_code] = store
    end
    store
  end


  def find_teacher_school_link teacher, new_school
    tsl = @found_teacher_school_links[teacher.legacy_user_id]
    unless tsl
      tsl = teacher.person_school_links.where(:school_id => new_school.id).first
      if(!tsl)
        tsl = PersonSchoolLink.create(:person_id => teacher.id, :school_id => new_school.id, :status => 'active') # should it be active????
      end
      @found_teacher_school_links[teacher.legacy_user_id] = tsl
    end
    tsl
  end
end
