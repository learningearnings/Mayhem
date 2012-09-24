#  migrate from old models to new models

class OldSchoolImporter
  def initalize
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
                    'Student',
                     'Teacher',
                    'SchoolAdmin',
                     nil,
                     'SchoolAdmin'
                    ]
      nu = Person.new
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
                             :created_at => old_user.usercreated,
                             :type => oldusertypes[old_user.usertypeID]
                           }, :as => :admin)
      if nu.save
        psl = PersonSchoolLink.new(:person_id => nu.id, :school_id => new_school.id, :status => 'active')
        psl.save
        retval = nu
      else
        retval = false
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
    puts "   --> #{classrooms} Classrooms #{total_users} Users Imported, #{total_errors} Errors  (#{elapsed_time} seconds)"
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
    imported_points = 0
    student_income = [2,4,10,12]
    cm = CreditManager.new
    found_teachers = {}
    OldPoint.includes(:old_otu_code).where(:userID => old_student.userID).where(:pointactionID => student_income ).each do |op|
      teacher = found_teachers[op.teacherID]
      unless teacher
        teacher = Person.find_by_legacy_user_id(op.teacherID)
        if teacher
          found_teachers[op.teacherID] = teacher
          imported_points = imported_points + op.points
          cm.issue_credits_to_student new_school, teacher, new_student, op.points
        else
          puts "Couldn't find teacherID #{op.teacherID} for #{op.pointID}"
          #            binding.pry
          next
        end
      end
    end
    imported_points
  end

  def import_reward old_reward_id, new_school
    old_reward = OldReward.find(old_reward_id)
    new_reward = nil
    if old_reward.partner_id > 0
      store = Spree::Store.find_by_code new_school.store_subdomain 

      new_reward = CreateStoreProduct.new(:name => old_reward.rewardtitle,
                                          :description => old_reward.rewarddesc,
                                           :store_code => new_school.store_subdomain,
                                           :quantity => old_reward.numberofrewards,
                                           :retail_price => old_reward.rewardpoints,
                                           :available_on => Time.now(),
                                           :image => old_reward.rewardimage) if store
    end
  end

end
