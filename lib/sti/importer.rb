load 'lib/sti/client.rb'
module STI
  class Importer

    def initialize options={}
      @imported_schools = []
    end

    def run!
      @api_schools = client.schools.parsed_response.each do |api_school|
        school = School.new(api_school_mapping(api_school))
        puts school.valid?
        puts school.errors.full_messages.to_sentence
        @imported_schools << school
      end

      @api_teachers = client.staff.parsed_response.each do |api_teacher|
        teacher = Teacher.new(api_teacher_mapping(api_teacher))
        puts teacher.valid?
        puts teacher.errors.full_messages.to_sentence
      end
    end

    private
    def api_teacher_mapping api_teacher
      {
        dob: api_teacher["DateOfBirth"],
        first_name: api_teacher["FirstName"],
        last_name: api_teacher["LastName"],
        grade: 5
      #  sti_id: api_teacher["Id"],
      #  email_address: api_teacher["EmailAddress"]
      }
    end

    def api_school_mapping api_school
      {
        name: api_school["Name"],
        address1: api_school["Address"],
        city: api_school["City"],
        sti_id: api_school["Id"]
      }
    end

    def client
      @client ||= Client.new
    end
  end
end
