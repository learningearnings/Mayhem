# This class should be supplied an sti_id and be called like so:
#  ex.) STI::Deactivators::StaffDeactivator.new(123).execute!

module STI
  module Deactivators
    class StaffDeactivator
      def initialize(data, district_guid)
        raise ArgumentError, 'STI staff id and district_guid must be given.' unless data.present? && district_guid.present?
        @staff_sti_id = data["Id"]
        @district_guid = district_guid
      end

      def execute!
        # To deactivate a person, two things must happen:
        #   1. Set person's status to inactive
        #   2. Set person's school links to inactive
        staff = Person.where(sti_id: @staff_sti_id, district_guid: @district_guid).first
        if staff
          staff.deactivate
          staff.person_school_links.map(&:deactivate)
        end
      end
    end
  end
end
