module STI
  module Updaters
    class StaffUpdater
      def initialize(data, district_guid)
        @data = data
        @district_guid = district_guid
      end

      def execute!
        # Update the person and their user record
        person = Person.where(district_guid: @district_guid, sti_id: @data["Id"]).first
        if person
          person.status = "active"
          person.update_attributes(mapping)
          person.user.update_attributes({email: @data["EmailAddress"], confirmed_at: Time.now})

          # Update their school links, start by disabling all, and only activating the ones being passed to us
          schools = Hash.from_xml(@data["SchoolsXml"])
          schools = schools["root"]
          if schools["row"].kind_of?(Array) 
            schools_ids = schools["row"].collect { | x | x["id"] }          
          else
            schools_ids = [schools["row"]["id"]]
          end       
          PersonSchoolLink.where(person_id: person.id).map(&:deactivate)
          if schools_ids 
            schools_ids.each do |school_id|
              school = School.where(:district_guid => @district_guid, :sti_id => school_id).first
              person_school_link = PersonSchoolLink.where(:person_id => person.id, :school_id => school.id).first_or_initialize
              person_school_link.status = "active"
              #### Fix for: Credits have been issued to the school but not distributed to the teachers. Updating can_distribute_credits with iNow response. - by Sonam####
              person_school_link.can_distribute_credits = @data["CanAwardCredits"] || @data["CanAwardCreditsClassroom"]
              person_school_link.save(validate: false)
            end
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
          grade: 5
        }
      end
    end
  end
end
