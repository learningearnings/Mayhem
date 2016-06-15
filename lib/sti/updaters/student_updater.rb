module STI
  module Updaters
    class StudentUpdater
      def initialize(data, district_guid)
        @data = data
        @district_guid = district_guid
      end

      def execute!
        person = Student.where(district_guid: @district_guid, sti_id: @data["Id"]).first
        person.update_attributes(person_mapping, as: :admin)
        person.user.update_attributes(user_mapping) if person.recovery_password.nil?
        schools = Hash.from_xml(@data["SchoolsXml"])
        if schools
          schools = schools["root"]
          if schools["row"].kind_of?(Array) 
            schools_ids = schools["row"].collect { | x | x["id"] }          
          else
            schools_ids = [schools["row"]["id"]]
          end
          schools_ids.each do |sti_school_id|          
            school = School.where(:district_guid => @district_guid, :sti_id => sti_school_id).first
            person_school_link = ::PersonSchoolLink.where(:person_id => person.id, :school_id => school.id).first_or_initialize
            person_school_link.skip_onboard_credits = true
            person_school_link.status = "active"
            person_school_link.save(:validate => false)
          end
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
          password_confirmation: password,
          confirmed_at: Time.now
        }
      end
    end
  end
end
