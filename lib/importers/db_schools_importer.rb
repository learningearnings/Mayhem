#  migrate from old models to new models

class OldSchoolImporter
  def initialize
    @new_school_rewards = Hash.new
    puts "Running some sql to fixup the MySQL db"
    OldSchool.connection.execute("update tbl_users set usercreated = '20100701' where date(usercreated) = '20100010'")
    OldSchool.connection.execute("update tbl_users set usercreated = '20100701' where date(usercreated) = '20100011'")
    OldReward.connection.execute("update tbl_rewards set partnerID = 0")
    OldUser.connection.execute("update tbl_users set virtual_bal = 0")
  end
  def reset
    OldSchool.connection.execute("update tbl_schools set ad_profile = 0 where ad_profile = 20")
=begin
      OldSchool.school_subset.each do |s|
        s.old_users.each do |u|
          p = Person.find_by_legacy_user_id(u.id)
          if p
            p.person_school_links.each do |l| l.destroy end
            if p.respond_to? :locker
              p.locker.destroy
            end
             if p.respond_to? :checking_account
              p.checking_account.destroy
            end
            if p.respond_to? :savings_account
              p.savings_account.destroy
            end
            if p.respond_to? :hold_account
              p.hold_account.destroy
            end
            if p.respond_to? :checking_account
              p.checking_account.destroy
            end
            if p.respond_to? :main_account
              p.main_account.destroy
            end
            if p.respond_to? :unredeemed_account
              p.unredeemed_account.destroy
            end
            if p.respond_to? :undeposited_account
              p.undeposited_account.destroy
            end
            if p.respond_to? :user
              p.user.destroy
            end
            p.destroy
          end
        end
        s.ad_profile = 1
        s.save
        ns = School.find_by_ad_profile(s.id)
        if ns
          ns.destroy
        end
      end
=end
  end

  def importable_schools
    if Rails.env.development?
      OldSchool.school_subset.order('schoolID asc')
    else
      OldSchool.order('schoolID asc')
    end
  end

  def imported_schools
    School.where('ad_profile >  1')
  end

  def import_school(s)
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
                         }, :as => :admin)

    if !ns.save
      # TODO What to do here?
      binding.pry
    end
    ns
  end

  def import_users(new_school, old_school)
    users = errors  = 0
    start_time = Time.now
#      old_school.old_users.where(:status_id => 200).each do |u|
    old_school.old_users.each do |u|
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
    return if oldusertypes[old_user.usertypeID].nil?
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
    nu.assign_attributes({:first_name => old_user.userfname,
                           :last_name => old_user.userlname,
                           :gender => old_user.usergender,
                           :salutation => old_user.usersalutation,
                           :user => Spree::User.new(:username => old_user.username,
                                                      :password => old_user.recoverypassword || old_user.username,
#TODO - don't require email
                                                    :email => old_user.useremail || "david+x#{old_user.userID}@learningearnings.com"
                                                    ),
                           :dob => old_user.dateofbirth,
                           :legacy_user_id => old_user.userID,
                           :grade => old_user.grade,
                           :status => old_user.status_id == 200 ? 'active' : 'inactive',
                           :created_at => old_user.usercreated
                         }, :as => :admin)
    if nu.save(:validate => false)
      if new_school
        psl = PersonSchoolLink.new(:person_id => nu.id, :school_id => new_school.id, :status => 'active')
        psl.save
      end
      retval = nu
    else
      retval = nil
    end
    retval
  end

  def import_classrooms(new_school,old_school)
    last_created_at = new_school.created_at
    puts "  --> #{old_school.classrooms.count} Classrooms to import for #{new_school.name}"
    start_time = Time.now

    total_errors = total_users = classrooms = users = errors  = 0
    old_school.classrooms.each do |c|
      # Add the classroom
      new_c = Classroom.where('school_id = ? and name = ?',new_school.id, c.classroomtitle).first
      next if new_c
      new_c = Classroom.new();
      begin
        c.classroomcreated = last_created_at = Date.parse(c.classroomcreated.to_s)
      rescue
        c.classroomcreated = last_created_at
      end
      new_c.update_attributes({:name => c.classroomtitle,
                                :status => c.status_id == 200 ? 'active' : 'inactive',
                                :school_id => new_school.id,
                                :created_at => c.classroomcreated
                              },:as => :admin)
      new_c.save
      p = Person.find_by_legacy_user_id(c.userID)
      add_person_to_classroom(p,new_c)
      users = errors = 0
      c.classroom_details.each do |cd|
        # Add the student to the classroom
        p = Person.find_by_legacy_user_id(cd.userID)
        add_person_to_classroom(p,new_c)
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
  end
  def add_person_to_classroom (person, classroom)
    return nil if !person || !classroom
    psl = PersonSchoolLink.where('person_id = ? and school_id = ?',person.id,classroom.school_id).first
    if !psl  # Student must have moved on...
      return false
    end
    pscl = PersonSchoolClassroomLink.where('person_school_link_id = ? and classroom_id = ?',psl.id,classroom.id).first
    if pscl
      return false
    end
    pscl = PersonSchoolClassroomLink.new(:person_school_link_id => psl.id,
                                         :classroom_id => classroom.id)
    if(person.type != 'Student')
      pscl.owner = true
    end
    if !pscl.save
      return false
    end
    return true
  end

  def import_products
  end


  def import_points(old_school, old_student, new_school)
    new_student = Student.find_by_legacy_user_id(old_student.userID)
    if new_student.nil?
#      puts "Missing student for tbl_users.userID = #{old_student.userID} - #{old_student.username}, #{old_student.school.school}"
      return 0;
    end
#    puts "Found student for tbl_users.userID = #{old_student.userID} - #{old_student.username}, #{old_student.school.school}"
    imported_points = 0
    student_income = [2,4,10,12]
    reward_purchases = [1]
    pointactions = [1,2,4,10,12]
    cm = CreditManager.new
    found_teachers = []
    OldPoint.includes(:old_otu_code).where(:userID => old_student.userID).where(:pointactionID => pointactions ).each do |op|
      if student_income.index(op.pointactionID) && op.old_otu_code
        teacher = found_teachers[op.old_otu_code.issuinguserID]
        if teacher.nil?
          teacher = Person.find_by_legacy_user_id(op.old_otu_code.issuinguserID)
          if teacher.nil?
            puts "Couldn't find teacherID #{op.old_otu_code.issuinguserID} for #{op.pointID}"
            #            binding.pry
            next
          else
            found_teachers[op.old_otu_code.issuinguserID] = teacher
          end
        end
        imported_points = imported_points + op.points
#        binding.pry if old_student.userID == 120435
        cm.issue_credits_to_student new_school, teacher, new_student, op.points
#        binding.pry if old_student.userID == 120435
      elsif reward_purchases.index(op.pointactionID) && op.rewardauctionID == 0
        new_reward = get_reward(op.rewardID, new_school)
        cm.transfer_credits_for_reward_purchase new_student, op.points.abs
      end
    end
    imported_points
  end

  def get_reward old_reward_id, new_school
    return if old_reward_id < 1
    product = @new_school_rewards["#{old_reward_id}:#{new_school.store_subdomain}"]
    return product if product
    old_reward = OldReward.find(old_reward_id)
    store = Spree::Store.find_by_code new_school.store_subdomain
    new_reward = CreateStoreProduct.new(:name => old_reward.rewardtitle,
                                        :description => old_reward.rewarddesc,
                                        :school => new_school,
                                        :quantity => old_reward.numberofrewards,
                                        :retail_price => old_reward.rewardpoints,
                                        :available_on => Time.now(),
                                        :image => old_reward.rewardimagepath).execute! if store
    @new_school_rewards["#{old_reward_id}:#{new_school.store_subdomain}"] = new_reward
    puts "New reward #{new_reward.id} for #{new_reward.name}"
  end
end
