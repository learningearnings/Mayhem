module STI
  module Creators
    class StudentCreator
      def initialize(data, district_guid)
        @data = data
        @district_guid = district_guid
      end

      def execute!
        person = Student.create(person_mapping, as: :admin)
        person.user.update_attributes(user_mapping) if person.recovery_password.nil?

        @data["Schools"].each do |sti_school_id|
          school = School.where(:district_guid => @district_guid, :sti_id => sti_school_id).first
          person_school_link = PersonSchoolLink.where(:person_id => person.id, :school_id => school.id).first_or_initialize
          person_school_link.skip_onboard_credits = true
          person_school_link.status = "active"
          person_school_link.save(:validate => false)
        end
      end

      private

      def person_mapping
        {
          sti_id: @data["Id"],
          gender: @data["Gender"] == "M" ? "Male" : "Female",
          district_guid: @district_guid,
          first_name: @data["FirstName"],
          last_name: @data["LastName"],
          grade: @data["GradeLevel"],
          status: "active"
        }
      end

      def user_mapping
        username = generate_username_for_district(@district_guid, @data["FirstName"], @data["LastName"])
        password = UUIDTools::UUID.random_create.to_s[0..3]
        {
          username: username,
          password: password,
          password_confirmation: password
        }
      end

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
end
