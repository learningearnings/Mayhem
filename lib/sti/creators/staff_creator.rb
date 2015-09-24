module STI
  module Creators
    class StaffCreator
      def initialize(data, district_guid)
        @district_guid = district_guid
        @data = data
      end

      def execute!
        Rails.logger.debug "AKT: StaffCreator #{@data.inspect}"
        person = Person.new(mapping)
        person.type = "Teacher"
        person.status = "active"
        person.save

        person.reload
        person.user.update_attributes({api_user: true, email: @data["EmailAddress"]})

        schools = Hash.from_xml(@data["SchoolsXml"])
        schools = schools["root"]
        if schools["row"] 
          school_ids = [schools["row"]["id"]]
        else
          school_ids = schools["rows"].collect { | x | x["id"] }
        end        
        school_ids.each do |school_id|
          person_school_link = PersonSchoolLink.where(person_id: person.id, school_id: school_id).first_or_initialize
          person_school_link.status = "active"
          person_school_link.save(validate: false)
        end
      end

      private

      def mapping
        {
          district_guid: @district_guid,
          sti_id: @data["Id"],
          dob: @data["DateOfBirth"],
          first_name: @data["FirstName"],
          last_name: @data["LastName"],
          can_distribute_credits: @data["CanAwardCredits"] || @data["CanAwardCreditsClassroom"],
          grade: 5
        }
      end
    end
  end
end
