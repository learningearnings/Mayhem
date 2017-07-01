module STI
  module Deactivators
    class StudentDeactivator
      def initialize(data, district_guid)
        @data = data
        @district_guid = district_guid
      end

      def execute!
        # Deactivating a person consist of two things:
        #   1. Set person's status to inactive
        #   2. Set person's school links to inactive
        person = Person.where(district_guid: @district_guid, sti_id: @data["Id"]).first
        if person
          person.update_attribute(:status, "inactive")
          PersonSchoolLink.joins(:person).where(id: person.id).update_all(status: "inactive")
        end  
      end
    end
  end
end
