load 'lib/sti/client.rb'
module STI
  class Importer

    def initialize options={}
      @client = options[:client]
      @district_guid   = options[:district_guid]
      @imported_schools = []
    end

    def run!
      Rails.logger.warn "*********************************"
      Rails.logger.warn "Starting import of schools"
      Rails.logger.warn "*********************************"
      @api_schools = client.schools.parsed_response.each do |api_school|
        school = School.where(district_guid: @district_guid, sti_id: api_school["Id"]).first_or_initialize
        school.update_attributes(api_school_mapping(api_school))
        school.save
        @imported_schools << school
      end

      Rails.logger.warn "*********************************"
      Rails.logger.warn "Starting import of teachers"
      Rails.logger.warn "*********************************"
      @api_teachers = client.staff.parsed_response.each do |api_teacher|
        schools = api_teacher["Schools"].map do |school_id|
          School.where(district_guid: @district_guid, sti_id: school_id).first.id
        end
        teacher = Teacher.where(district_guid: @district_guid, sti_id: api_teacher["Id"]).first_or_initialize
        teacher.update_attributes(api_teacher_mapping(api_teacher))
        schools.each do |school|
          person_school_link = ::PersonSchoolLink.where(:person_id => teacher.id, :school_id => school, :status => "active").first_or_initialize
          person_school_link.save(:validate => false)
        end
      end

      Rails.logger.warn "*********************************"
      Rails.logger.warn "Starting import of classrooms"
      Rails.logger.warn "*********************************"
      @api_classrooms = client.sections.parsed_response.each do |api_classroom|
        classroom = Classroom.where(district_guid: @district_guid, sti_id: api_classroom["Id"]).first_or_initialize
        classroom.update_attributes(api_classroom_mapping(api_classroom))
        teacher = Teacher.where(:district_guid => @district_guid, :sti_id => api_classroom["TeacherId"]).first
        person_school_link = teacher.person_school_links.includes(:school).where("schools.district_guid" => @district_guid, "schools.sti_id" => api_classroom["SchoolId"]).first
        person_school_classroom_link = PersonSchoolClassroomLink.where(:person_school_link_id => person_school_link.id, :classroom_id => classroom.id).first_or_initialize
        person_school_classroom_link.save
      end

      Rails.logger.warn "*********************************"
      Rails.logger.warn "Starting import of students"
      Rails.logger.warn "*********************************"
      @api_students = client.students.parsed_response.each do |api_student|
        student = Student.where(district_guid: @district_guid, sti_id: api_student["Id"]).first_or_initialize
        student.update_attributes(api_student_mapping(api_student))
        student.user.update_attributes(api_student_user_mapping(api_student))
        api_student["Schools"].each do |sti_school_id|
          school = School.where(:district_guid => @district_guid, :sti_id => sti_school_id).first
          person_school_link = ::PersonSchoolLink.where(:person_id => student.id, :school_id => school.id, :status => "active").first_or_initialize
          person_school_link.save(:validate => false)
        end
      end


      Rails.logger.warn "*********************************"
      Rails.logger.warn "Starting import of students into classrooms"
      Rails.logger.warn "*********************************"
      client.rosters.parsed_response.each do |api_roster|
        classroom = Classroom.where(:district_guid => @district_guid, :sti_id => api_roster["SectionId"]).first
        student = Student.where(:district_guid => @district_guid, :sti_id => api_roster["StudentId"]).first
        person_school_link = student.person_school_links.where(:school_id => classroom.school.id).first
        person_school_classroom_link = PersonSchoolClassroomLink.where(:person_school_link_id => person_school_link.id, :classroom_id => classroom.id).first_or_initialize
        person_school_classroom_link.save
      end

      Rails.logger.warn "*********************************"
      Rails.logger.warn "Notifying STI of successful sync"
      Rails.logger.warn "*********************************"
      @imported_schools.each do |school|
        client.set_school_synced(school.sti_id)
      end
    end

    private
    def api_classroom_mapping api_classroom
      {
        school_id: School.where(district_guid: @district_guid, sti_id: api_classroom["SchoolId"]).first.id,
        name: api_classroom["Name"],
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
        district_guid: @district_guid,
        first_name: api_student["FirstName"],
        last_name: api_student["LastName"],
        grade: api_student["GradeLevel"]
      }
    end

    def api_student_user_mapping api_student
      password = UUIDTools::UUID.random_create.to_s[0..3]
      {
        username: api_student["FirstName"][0] + api_student["LastName"][0..4],
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
  end
end
