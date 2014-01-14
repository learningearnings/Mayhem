load 'lib/sti/client.rb'
module STI
  class Importer

    def initialize options={}
      @imported_schools = []
    end

    def run!
      puts "******************************************************"
      puts "Importing Schools"
      puts "******************************************************"
      @api_schools = client.schools.parsed_response.each do |api_school|
        school = School.where(sti_id: api_school["Id"]).first_or_initialize
        school.update_attributes(api_school_mapping(api_school))
        school.save
        @imported_schools << school
      end

      puts "******************************************************"
      puts "Importing Teachers"
      puts "******************************************************"
      @api_teachers = client.staff.parsed_response.each do |api_teacher|
        schools = api_teacher["Schools"].map do |school_id|
          School.where(sti_id: school_id).first.id
        end
        teacher = Teacher.where(sti_id: api_teacher["Id"]).first_or_initialize
        teacher.update_attributes(api_teacher_mapping(api_teacher))
        schools.each do |school|
          person_school_link = ::PersonSchoolLink.where(:person_id => teacher.id, :school_id => school, :status => "active").first_or_initialize
          person_school_link.save(:validate => false)
        end
      end

      puts "******************************************************"
      puts "Importing Classrooms"
      puts "******************************************************"
      @api_classrooms = client.sections.parsed_response.each do |api_classroom|
        classroom = Classroom.where(sti_id: api_classroom["Id"]).first_or_initialize
        classroom.update_attributes(api_classroom_mapping(api_classroom))
        teacher = Teacher.where(:sti_id => api_classroom["TeacherId"]).first
        person_school_link = teacher.person_school_links.includes(:school).where("schools.sti_id" => api_classroom["SchoolId"]).first
        person_school_classroom_link = PersonSchoolClassroomLink.where(:person_school_link_id => person_school_link.id, :classroom_id => classroom.id).first_or_initialize
        person_school_classroom_link.save
        puts person_school_classroom_link.errors.full_messages.to_sentence
      end

      puts "******************************************************"
      puts "Importing Students"
      puts "******************************************************"
      @api_students = client.students.parsed_response.each do |api_student|
        student = Student.where(sti_id: api_student["Id"]).first_or_initialize
        student.update_attributes(api_student_mapping(api_student))
        school = School.where(:sti_id => api_student["Schools"]).first
        person_school_link = ::PersonSchoolLink.where(:person_id => student.id, :school_id => school.id, :status => "active").first_or_initialize
        person_school_link.save(:validate => false)
      end


      puts "******************************************************"
      puts "Importing Students into Classrooms"
      puts "******************************************************"
      client.rosters.parsed_response.each do |api_roster|
        classroom = Classroom.where(:sti_id => api_roster["SectionId"]).first
        student = Student.where(:sti_id => api_roster["StudentId"]).first
        person_school_link = student.person_school_links.where(:school_id => classroom.school.id).first
        person_school_classroom_link = PersonSchoolClassroomLink.where(:person_school_link_id => person_school_link.id, :classroom_id => classroom.id).first_or_initialize
        person_school_classroom_link.save
      end
    end

    private
    def api_classroom_mapping api_classroom
      {
        school_id: School.where(sti_id: api_classroom["SchoolId"]).first.id,
        name: api_classroom["Name"],
        sti_id: api_classroom["Id"]
      }
    end

    def api_teacher_mapping api_teacher
      {
        dob: api_teacher["DateOfBirth"],
        first_name: api_teacher["FirstName"],
        last_name: api_teacher["LastName"],
        grade: 5,
        sti_id: api_teacher["Id"]
      }
    end

    def api_student_mapping api_student
      {
        sti_id: api_student["Id"],
        first_name: api_student["FirstName"],
        last_name: api_student["LastName"],
        grade: api_student["GradeLevel"]
      }
    end

    def api_school_mapping api_school
      {
        name: api_school["Name"],
        address1: api_school["Address"] || "Blank",
        city: api_school["City"] || "Blank",
        state_id: State.first.id,
        zip: "35071",
        sti_id: api_school["Id"]
      }
    end

    def client
      @client ||= Client.new
    end
  end
end
