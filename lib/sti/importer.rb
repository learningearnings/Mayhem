load 'lib/sti/client.rb'
module STI
  class Importer

    def initialize options={}
      @client = options[:client]
      @district_guid   = options[:district_guid]
      @imported_schools = []
    end

    def run!
      sti_schools = client.schools.parsed_response
      current_schools_for_district = School.where(district_guid: @district_guid).pluck(:sti_id)
      begin
        sti_school_ids = sti_schools.map {|school| school["Id"]}
      rescue Exception => e
        Rails.logger.warn "*****************************************"
        Rails.logger.warn client.schools.response
        Rails.logger.warn "*****************************************"
        raise "ERROR ON SCHOOLS -- CLIENT: #{client.inspect} -- RESPONSE: #{client.schools.response}"
      end   
      
      # Schools that are synced in our DB but are no longer listed in the api
      (current_schools_for_district - sti_school_ids).each do |school_sti_id|
        school = School.where(:district_guid => @district_guid, :sti_id => school_sti_id).first
        school.deactivate
        client.set_school_synced(school.sti_id, false)
      end
      @api_schools = sti_schools.each do |api_school|
        school = School.where(district_guid: @district_guid, sti_id: api_school["Id"]).first_or_initialize
        school.credits_scope = "School-Wide" unless school.credits_scope        
        school.update_attributes(api_school_mapping(api_school))
        school.reload
        school.activate
        @imported_schools << school
      end

      staff_response = client.async_staff.parsed_response
      
      sti_staff = staff_response["Rows"]
      current_staff_for_district = Person.where(:district_guid => @district_guid).pluck(:sti_id)
      sti_staff_ids = sti_staff.map {|staff| staff["Id"]}
      # Persons in our system that weren't in their api need to be deactivated
      (current_staff_for_district - sti_staff_ids).each do |sti_staff_id|
        if teacher = Person.where(:district_guid => @district_guid, :sti_id => sti_staff_id).first
          teacher.person_school_links.map(&:deactivate)
          begin
            teacher.deactivate
          rescue
            Rails.logger.error "SYNC-ERROR: Could not deactivate teacher #{teacher.inspect}"
          end
        end
      end
      
      @api_teachers = sti_staff.each do |api_teacher|
        begin
          teacher = Person.where(district_guid: @district_guid, sti_id: api_teacher["Id"]).first_or_initialize
          is_new_teacher = teacher.new_record?
          teacher.type ||= "Teacher"
          teacher.status = "active"
          teacher.update_attributes(api_teacher_mapping(api_teacher))
          teacher.reload
          teacher.user.update_attributes({:api_user => true, :email => api_teacher["EmailAddress"], confirmed_at: Time.now})
          if api_teacher["Schools"]
            school_ids = School.where(district_guid: @district_guid, sti_id: api_teacher["Schools"]).pluck(:id)
          elsif api_teacher["SchoolsXml"]
            xmldata = Hash.from_xml api_teacher["SchoolsXml"]
            if xmldata["root"]["row"].kind_of?(Array)
              school_ids = xmldata["root"]["row"].collect { | school | school["id"] }
            else        
              school_ids = [ xmldata["root"]["row"]["id"] ]
            end
          else
            school_ids = []
          end
          school_ids.each do |school_id|
            school = School.where(district_guid: @district_guid, sti_id: school_id).first
            person_school_link = ::PersonSchoolLink.where(:person_id => teacher.id, :school_id => school.id).first_or_initialize
            person_school_link.status = "active"
            if is_new_teacher
              person_school_link.can_distribute_credits = api_teacher["CanAwardCredits"] || api_teacher["CanAwardCreditsClassroom"]
            end
            person_school_link.save(:validate => false)
          end
        rescue => e
          puts "************** Teacher Skipped #{api_teacher.inspect} #{e.inspect}"
          Rails.logger.warn "************** Teacher Skipped #{api_teacher.inspect} #{e.inspect}"
        end
      end

      # Loop through classrooms and sync in much the same way as above
      classrooms_response = client.async_sections.parsed_response
      sti_classrooms = classrooms_response["Rows"]
      current_classrooms_for_district = Classroom.where(district_guid: @district_guid).pluck(:sti_id)
      sti_classroom_ids = sti_classrooms.map {|classroom| classroom["Id"]}
      (current_classrooms_for_district - sti_classroom_ids).each do |sti_classroom_id|
        classroom = Classroom.where(:district_guid => @district_guid, :sti_id => sti_classroom_id).first
        ClassroomDeactivator.new(classroom.id).execute!
      end
      
      @api_classrooms = sti_classrooms.each do |api_classroom|
        classroom = Classroom.where(district_guid: @district_guid, sti_id: api_classroom["Id"]).first_or_initialize
        classroom.update_attributes(api_classroom_mapping(api_classroom))
        classroom.reload
        ClassroomActivator.new(classroom.id).execute!
        teacher = Teacher.where(:district_guid => @district_guid, :sti_id => api_classroom["TeacherId"]).first
        next unless teacher
        person_school_link = teacher.person_school_links.includes(:school).where("schools.district_guid" => @district_guid, "schools.sti_id" => api_classroom["SchoolId"]).first
        if person_school_link and classroom
          PersonSchoolClassroomLink.where(:person_school_link_id => person_school_link.id, :classroom_id => classroom.id).first_or_create    
        end
      end

      # Deactivate all students for school and just let the Sync reactivate students
      school_ids = School.where(district_guid: @district_guid).pluck(:id).uniq
      #psls = PersonSchoolLink.joins(:person).where(school_id: school_ids, person: { type: 'Student' })
      # Added where students sti_id is not null in Rails 3 way
      psls = PersonSchoolLink.joins(:person).where("person_school_links.school_id IN (?) AND people.type = ? AND people.sti_id IS NOT NULL", school_ids, 'Student')
      students = Student.where(id: psls.pluck(:person_id)).update_all(status: "inactive")
      psls.update_all(status: "inactive")

      # Activate/Create students that we pull from STI
      students_response = client.async_students.parsed_response
      students_response["Rows"].each do |api_student|
        begin
          student = Student.where(district_guid: @district_guid, sti_id: api_student["Id"]).first_or_initialize
          student.update_attributes(api_student_mapping(api_student), as: :admin)
          student.user.update_attributes(api_student_user_mapping(api_student)) if student.recovery_password.nil?
          student.user.confirmed_at = Time.now
          student.user.save
          if api_student["Schools"]
            school_ids = School.where(district_guid: @district_guid, sti_id: api_student["Schools"]).pluck(:id)
          elsif api_student["SchoolsXml"]
            xmldata = Hash.from_xml api_student["SchoolsXml"]
            if xmldata["root"]["row"].kind_of?(Array)
              school_ids = xmldata["root"]["row"].collect { | school | school["id"] }
            else
              school_ids = [ xmldata["root"]["row"]["id"] ]
            end
          else
            school_ids = []
          end
          
          
          school_ids.each do |sti_school_id|
            school = School.where(:district_guid => @district_guid, :sti_id => sti_school_id).first
            person_school_link = ::PersonSchoolLink.where(:person_id => student.id, :school_id => school.id).first_or_initialize
            person_school_link.skip_onboard_credits = true
            person_school_link.status = "active"
            person_school_link.save(:validate => false)
          end
        rescue => e
          puts "************** Student Skipped #{api_student.inspect} #{e.inspect}"
          Rails.logger.warn "************** Student Skipped #{api_student.inspect} #{e.inspect}"
        end
      end

      # Rosters is list of students in classroom
      # Munge the data so that we can loop over each student and create all of
      # their classrooms at once and also, we can remove them from classrooms
      # they are not suppose to be in.
      #  Output of hash should be {student_id: [classroom_id, classroom_id]}
      students_hash = {}
      students_hash.default = []
      rosters_response = client.async_rosters.parsed_response
      rosters_response["Rows"].each do |entry|
        # An entry currently looks like this {"SectionId" => 1000, "StudentId" => 1208}
        students_hash[entry["StudentId"]] = students_hash[entry["StudentId"]] + [entry["SectionId"]]
      end

      students_hash.each_pair do |sti_student_id, sti_classroom_ids|
        next if sti_student_id.nil?
        student = Student.where(district_guid: @district_guid, sti_id: sti_student_id, status: 'active').first
        next if student.nil? or student.school.nil? or student.school.id.nil?
        school_id = student.school.id
        psl = student.person_school_links.where(school_id: school_id).first
        next unless psl
        
        # Deactivate all existing classroom links
        PersonSchoolClassroomLink.where(id: student.person_school_classroom_links.pluck(:id)).each do |pscl|
          #Only deactive INOW classroom links
          pscl.update_attribute(:status, "inactive") if !pscl.classroom.sti_id.nil?
        end
     
        # Update the new classrooms for the student
        sti_classroom_ids.compact.each do |sti_classroom_id|
          classroom = Classroom.where(district_guid: @district_guid, sti_id: sti_classroom_id).first
          if classroom
              pscl = PersonSchoolClassroomLink.where(person_school_link_id: psl.id, classroom_id: classroom.id).first_or_create
              pscl.activate      
          end
        end
        
      end
      newly_synced_schools = sti_schools.select {|school| school["IsSyncComplete"] != true}.map{|school| School.where(:district_guid => @district_guid, :sti_id => school["Id"]).first }
      BuckDistributor.new(newly_synced_schools).run

      newly_synced_schools.each do |school|
        request = client.set_school_synced(school.sti_id)
        raise "Couldn't set school synced got: #{request.response.inspect}" if request.response.code != "204"
      end

      ##### Set current versions #####
      district = District.where(guid: @district_guid).first_or_create
      district.update_attributes({
        current_staff_version:   staff_response["CurrentVersion"],
        current_student_version: students_response["CurrentVersion"],
        current_section_version: classrooms_response["CurrentVersion"],
        current_roster_version:  rosters_response["CurrentVersion"]
      })
    end

    private
    def api_classroom_mapping api_classroom
      classroom_name_period_addition = ""
      classroom_name_period_addition = " " + api_classroom["Periods"] unless api_classroom["Periods"].blank?
      {
        school_id: School.where(district_guid: @district_guid, sti_id: api_classroom["SchoolId"]).first.id,
        name: api_classroom["Name"] + classroom_name_period_addition,
        sti_id: api_classroom["Id"],
        district_guid: @district_guid
      }
    end

    def api_teacher_mapping api_teacher
      {
        dob: api_teacher["DateOfBirth"],
        first_name: api_teacher["FirstName"],
        last_name: api_teacher["LastName"],
        grade: 5,
        sti_id: api_teacher["Id"],
        district_guid: @district_guid
      }
    end

    def api_student_mapping api_student
      {
        sti_id: api_student["Id"],
        gender: api_student["Gender"] == "M" ? "Male" : "Female",
        district_guid: @district_guid,
        first_name: api_student["FirstName"],
        last_name: api_student["LastName"],
        grade: api_student["GradeLevel"],
        status: "active"
      }
    end

    def api_student_user_mapping api_student
      username = generate_username_for_district(@district_guid, api_student["FirstName"], api_student["LastName"])
      password = UUIDTools::UUID.random_create.to_s[0..3]
      {
        username: username,
        password: password,
        password_confirmation: password
      }
    end

    def api_school_mapping api_school
      {
        name: api_school["Name"],
        address1: api_school["Address"] || "Blank",
        city: api_school["City"] || "Blank",
        state_id: (api_school["State"] ? (State.where(abbr: api_school["State"]).first.id) : (State.first.id)),
        zip: (api_school["PostalCode"] == nil or api_school["PostalCode"].strip.blank?) ? "35071" : (api_school["PostalCode"].strip),
        sti_id: api_school["Id"],
        min_grade: 1,
        max_grade: 12,
        district_guid: @district_guid
      }
    end

    def client
      @client ||= Client.new
    end

    # Recursively generate usernames until we find one that is unique
    def generate_username_for_district(district_guid, first_name, last_name, iteration = 0)
      username = first_name.downcase[0] + last_name.downcase[0..4]
      username += iteration.to_s if iteration > 0
      return username if username_unique_for_district?(district_guid, username)
      return generate_username_for_district(district_guid, first_name, last_name, iteration + 1)
    end

    def username_unique_for_district?(district_guid, username)
      !Student.joins(:user).where(:district_guid => district_guid, :user => {:username => username}).any?
    end
  end
end
