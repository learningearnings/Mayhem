module STI
  module Synchronizers
    class StaffSynchronizer < BaseSynchronizer
      def execute!
        deleted.each { |member| STI::Deactivators::StaffDeactivator.new(member, district_guid).execute! }
        inserted.each{ |member| STI::Creators::StaffCreator.new(member, district_guid).execute! }
        updated.each { |member| STI::Updaters::StaffUpdater.new(member, district_guid).execute! }
      end
    end
  end
end
