#  migrate from old models to new models

# Couldn't figure out a way to get this connection information 
# out of the classes in this file

class OldState < ActiveRecord::Base
  establish_connection({:adapter => 'mysql2',
  :database =>'Snapshot',
  :username =>'import',
  :password => 'i82much'})
  self.table_name = 'tbl_states'
  self.primary_key = 'stateID'
end

class OldSchool < ActiveRecord::Base
  establish_connection({:adapter => 'mysql2',
  :database =>'Snapshot',
  :username =>'import',
  :password => 'i82much'})
  self.table_name = 'tbl_schools'
  self.primary_key = 'schoolID'

#  scope :school_subset,  where(:schoolID => [91,215,229,221,98,830,483,412,96,633,873,538,121,94,277]).where('status_id = 200 and ad_profile < 21')
  scope :school_subset,  where(:schoolID => [98,215,229]).where('ad_profile < 20')

  belongs_to :state, :class_name => OldState
  has_many :old_users, :foreign_key => :schoolID
  has_many :classrooms, :foreign_key => :schoolID, :class_name => 'OldClassroom'
end

class OldUser < ActiveRecord::Base
  establish_connection({:adapter => 'mysql2',
  :database =>'Snapshot',
  :username =>'import',
  :password => 'i82much'})
  self.table_name = 'tbl_users'
  self.primary_key = 'userID'
  belongs_to :school, :class_name => OldSchool,:foreign_key => :schoolID,  :inverse_of => :old_users
end

class OldClassroom < ActiveRecord::Base
  establish_connection({:adapter => 'mysql2',
  :database =>'Snapshot',
  :username =>'import',
  :password => 'i82much'})
  self.table_name = 'tbl_classrooms'
  self.primary_key = 'classroomID'
  belongs_to :teacher, :class_name => OldUser, :foreign_key => :userID
  has_many :classroom_details, :class_name => 'OldClassroomDetail', :foreign_key => :classroomID
  has_many :students, :class_name => OldUser, :foreign_key => :userID
  belongs_to :school, :class_name => OldSchool,:foreign_key => :schoolID,  :inverse_of => :old_users
end

class OldClassroomDetail < ActiveRecord::Base
  establish_connection({:adapter => 'mysql2',
  :database =>'Snapshot',
  :username =>'import',
  :password => 'i82much'})
  self.table_name = 'tbl_classroomdetails'
  self.primary_key = 'classroomdetailID'
  belongs_to :old_classroom, :foreign_key => :classroomID,  :inverse_of => :students
end


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
    oldusertypes = ['', # Should be no zeros...
                    'Student',
                     'Teacher',
                    'SchoolAdmin',
                     nil,
                     'SchoolAdmin'
                    ]
    users = errors  = 0
    start_time = Time.now
#      old_school.old_users.where(:status_id => 200).each do |u|
    old_school.old_users.each do |u|
      nu = Person.new
      begin
        u.dateofbirth = Date.parse(u.dateofbirth.to_s)
      rescue
        u.dateofbirth = nil
      end
      begin
        u.usercreated = Date.parse(u.usercreated)
      rescue
        u.usercreated = Date.parse('20100701 00:00:00')
      end
      nu.assign_attributes({:first_name => u.userfname,
                             :last_name => u.userlname,
                             :gender => u.usergender,
                             :salutation => u.usersalutation,
                             :user => Spree::User.new(:username => u.username,
                                                      :password => u.recoverypassword || u.username,
#TODO - don't require email
                                                      :email => u.useremail || "david+x#{u.userID}@learningearnings.com"
                                                      ),
                             :dob => u.dateofbirth,
                             :legacy_user_id => u.userID,
                             :grade => u.grade,
                             :status => u.status_id == 200 ? 'active' : 'inactive',
                             :created_at => u.usercreated,
                             :type => oldusertypes[u.usertypeID]
                           }, :as => :admin)
      if nu.save(:validate => false)
        users = users + 1
        psl = PersonSchoolLink.new(:person_id => nu.id, :school_id => new_school.id, :status => 'active')
        psl.save(:validate => false)
      else
        errors = errors + 1
#          binding.pry
      end
    end
    end_time = Time.now
    elapsed_time = (end_time - start_time).round(2)
    userspersec = (users / elapsed_time).round(2)
    puts "   > #{users} Users Imported, #{errors} Errors  (#{elapsed_time} seconds) #{userspersec} per sec" 
  end

  def import_classrooms(new_school,old_school)
    last_created_at = new_school.created_at
    puts "   --> #{old_school.classrooms.count} Classrooms to import for #{new_school.name}"
    start_time = Time.now

    total_errors = total_users = classrooms = users = errors  = 0
    old_school.classrooms.each do |c|
      # Add the classroom
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
#      puts "Importing -> #{new_c.name}"
      # Add the teacher to the classroom
      p = Person.find_by_legacy_user_id(c.userID)
      add_person_to_classroom(p,new_c)
      users = errors = 0
      c.classroom_details.each do |cd|
        # Add the student to the classroom
        p = Person.find_by_legacy_user_id(cd.userID)
        add_person_to_classroom(p,new_c)
        users = users + 1
      end
#      puts " ----> Imported -> #{users} users for Classroom \"#{new_c.name}\""
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
#          puts "found classroom a link for school link #{psl.id} and classroom #{new_c.id} --- Skipping"
#          binding.pry
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



end
