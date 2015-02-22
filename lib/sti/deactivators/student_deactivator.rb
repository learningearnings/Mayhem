module STI
  module Deactivators
    class StudentDeactivator
      def initialize(sti_id, district_guid)
        @sti_id = sti_id
        @district_guid = district_guid
      end

      def execute!
        # Deactivating a person consist of two things:
        #   1. Set person's status to inactive
        #   2. Set person's school links to inactive
        person = Person.find(district_guid: @district_guid, sti_id: @sti_id)
        person.update_attribute(:status, "inactive")
        PersonSchoolLink.joins(:person).where(id: psls.pluck(:person_id)).update_all(status: "inactive")
      end
    end
  end
end
