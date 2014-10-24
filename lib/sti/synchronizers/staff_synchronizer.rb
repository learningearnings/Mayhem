module STI
  module Synchronizers
    class StaffSynchronizer
      def initialize(data, district_guid)
        raise ArgumentError, 'data must be given.' unless data.present?
        @data = data
        @district_guid = district_guid
      end

      def execute!
        deleted_members.each { |member| STI::Deactivators::StaffDeactivator.new(member, district_guid).execute! }
        inserted_members.each{ |member| STI::Creators::StaffCreator.new(member, district_guid).execute! }
        updated_members.each { |member| STI::Updaters::StaffUpdater.new(member, district_guid).execute! }
      end

      private

      def deleted_members
        @data["Deleted"]
      end

      def inserted_members
        @data["Inserted"]
      end

      def updated_members
        @data["Updated"]
      end
    end
  end
end
