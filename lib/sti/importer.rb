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
        school = School.new(api_school_mapping(api_school))
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
        teacher = Teacher.create(api_teacher_mapping(api_teacher))
        schools.each do |school|
          person_school_link = ::PersonSchoolLink.new(:person_id => teacher.id, :school_id => school, :status => :active)
          person_school_link.save(:validate => false)
        end
      end

      puts "******************************************************"
      puts "Importing Classrooms"
      puts "******************************************************"
      @api_classrooms = client.sections.parsed_response.each do |api_classroom|
        classroom = Classroom.new(api_classroom_mapping(api_classroom))
        classroom.save
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
=begin
        user: {
          email_address: api_teacher["EmailAddress"]
        },
=end
        sti_id: api_teacher["Id"]
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
