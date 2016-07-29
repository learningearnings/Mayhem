module STI
  module Creators
    class StaffCreator
      def initialize(data, district_guid)
        @district_guid = district_guid
        @data = data
      end

      def execute!
        #Rails.logger.debug "AKT: StaffCreator #{@data.inspect}"
        person = Person.new(mapping)
        person.type = "Teacher"
        person.status = "active"
        if person.save       
          person.reload
          person.user.update_attributes({api_user: true, email: @data["EmailAddress"], confirmed_at: Time.now})

          schools = Hash.from_xml(@data["SchoolsXml"])
          if schools == nil
            Rails.logger.error("Bad XML response for guid: #{@district_guid} schools: #{@data.inspect}")
            return
          end
          schools = schools["root"]
          if schools["row"].kind_of?(Array) 
            schools_ids = schools["row"].collect { | x | x["id"] }          
          else
            schools_ids = [schools["row"]["id"]]
          end        
          schools_ids.each do |school_id|
            school = School.where(:district_guid => @district_guid, :sti_id => school_id).first
            person_school_link = PersonSchoolLink.where(:person_id => person.id, :school_id => school.id).first_or_initialize
            person_school_link.status = "active"
            person_school_link.save(validate: false)
          end
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
