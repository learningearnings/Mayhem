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
        raise e
      end
      # Schools that are synced in our DB but are no longer listed in the api
      (current_schools_for_district - sti_school_ids).each do |school_sti_id|
        school = School.where(:district_guid => @district_guid, :sti_id => school_sti_id).first
        unless school.status == "inactive"
          school.deactivate!
          client.set_school_synced(school.sti_id, false)
        end
      end
      @api_schools = sti_schools.each do |api_school|
        school = School.where(district_guid: @district_guid, sti_id: api_school["Id"]).first_or_initialize
        school.update_attributes(api_school_mapping(api_school))
        school.reload && school.activate! unless school.status == "active"
        school.save
        @imported_schools << school
      end

      sti_staff = client.staff.parsed_response
      current_staff_for_district = Teacher.where(:district_guid => @district_guid).pluck(:sti_id)
      sti_staff_ids = sti_staff.map {|staff| staff["Id"]}
      # Teachers in our system that weren't in their api need to be deactivated
      (current_staff_for_district - sti_staff_ids).each do |sti_staff_id|
        teacher = Teacher.where(:district_guid => @district_guid, :sti_id => sti_staff_id).first
        teacher.deactivate! unless teacher.status == "inactive"
      end
      #TODO: Teachers never seem to get deactivated from a school. We need to deactivate person school links
      @api_teachers = sti_staff.each do |api_teacher|
        begin
          schools = api_teacher["Schools"].map do |school_id|
            School.where(district_guid: @district_guid, sti_id: school_id).first.id
          end
          teacher = Teacher.where(district_guid: @district_guid, sti_id: api_teacher["Id"]).first_or_initialize
          teacher.update_attributes(api_teacher_mapping(api_teacher))
          teacher.reload
          teacher.user.update_attributes({:api_user => true, :email => api_teacher["EmailAddress"]})
          teacher.reload && teacher.activate! unless teacher.status == "active"
          schools.each do |school|
            person_school_link = ::PersonSchoolLink.where(:person_id => teacher.id, :school_id => school, :status => "active").first_or_initialize
            person_school_link.save(:validate => false)
          end
        rescue => e
          puts "************** Skipped #{api_teacher} #{e.inspect}"
          Rails.logger.warn "************** Skipped #{api_teacher}"
        end
      end

      # Loop through classrooms and sync in much the same way as above
      sti_classrooms = client.sections.parsed_response
      current_classrooms_for_district = Classroom.where(district_guid: @district_guid).pluck(:sti_id)
      sti_classroom_ids = sti_classrooms.map {|classroom| classroom["Id"]}
      (current_classrooms_for_district - sti_classroom_ids).each do |sti_classroom_id|
        classroom = Classroom.where(:district_guid => @district_guid, :sti_id => sti_classroom_id).first
        classroom.deactivate! unless classroom.status == "inactive"
      end
      @api_classrooms = sti_classrooms.each do |api_classroom|
        classroom = Classroom.where(district_guid: @district_guid, sti_id: api_classroom["Id"]).first_or_initialize
        classroom.update_attributes(api_classroom_mapping(api_classroom))
        classroom.reload && classroom.activate! unless classroom.status == "active"
        teacher = Teacher.where(:district_guid => @district_guid, :sti_id => api_classroom["TeacherId"]).first
        person_school_link = teacher.person_school_links.includes(:school).where("schools.district_guid" => @district_guid, "schools.sti_id" => api_classroom["SchoolId"]).first
        person_school_classroom_link = PersonSchoolClassroomLink.where(:person_school_link_id => person_school_link.id, :classroom_id => classroom.id).first_or_initialize
        person_school_classroom_link.save
      end

      sti_students = client.students.parsed_response
      current_students_for_district = Student.where(district_guid: @district_guid).pluck(:sti_id)
      sti_student_ids = sti_students.map {|student| student["Id"]}
      (current_students_for_district - sti_student_ids).each do |sti_student_id|
        student = Student.where(district_guid: @district_guid, sti_id: sti_student_id).first
        student.deactivate! unless student.status == "inactive"
      end
      @api_students = sti_students.each do |api_student|
        begin
          student = Student.where(district_guid: @district_guid, sti_id: api_student["Id"]).first_or_initialize
          student.update_attributes(api_student_mapping(api_student))
          student.user.update_attributes(api_student_user_mapping(api_student)) if student.recovery_password.nil?
          student.reload && student.activate! unless student.status == "active"
          api_student["Schools"].each do |sti_school_id|
            school = School.where(:district_guid => @district_guid, :sti_id => sti_school_id).first
            person_school_link = ::PersonSchoolLink.where(:person_id => student.id, :school_id => school.id, :status => "active").first_or_initialize
            person_school_link.skip_onboard_credits = true if person_school_link.new_record?
            person_school_link.save(:validate => false)
          end
        rescue => e
          puts "************** Skipped #{api_student} #{e.inspect}"
          Rails.logger.warn "************** Skipped #{api_student}"
        end
      end


      # Rosters is list of students in classroom
      client.rosters.parsed_response.each do |api_roster|
        classroom = Classroom.where(:district_guid => @district_guid, :sti_id => api_roster["SectionId"]).first
        next if classroom.nil?
        student = Student.where(:district_guid => @district_guid, :sti_id => api_roster["StudentId"]).first
        next if student.nil?
        person_school_link = student.person_school_links.where(:school_id => classroom.school.id).first
        next if person_school_link.nil?
        person_school_classroom_link = PersonSchoolClassroomLink.where(:person_school_link_id => person_school_link.id, :classroom_id => classroom.id).first_or_initialize
        person_school_classroom_link.save
      end

      newly_synced_schools = sti_schools.select {|school| school["IsSyncComplete"] != true}.map{|school| School.where(:district_guid => @district_guid, :sti_id => school["Id"]).first }
      BuckDistributor.new(newly_synced_schools).run

      newly_synced_schools.each do |school|
        request = client.set_school_synced(school.sti_id)
        raise "Couldn't set school synced got: #{request.response.inspect}" if request.response.code != "204"
      end
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
        can_distribute_credits: api_teacher["CanAwardCredits"] || api_teacher["CanAwardCreditsClassroom"],
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
        grade: api_student["GradeLevel"]
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
        state_id: State.first.id,
        zip: "35071",
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
