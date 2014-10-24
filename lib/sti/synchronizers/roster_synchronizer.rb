module STI
  module Synchronizers
    class RosterSynchronizer
      def initialize(data, district_guid)
        @data = data
        @district_guid = district_guid
      end

      def execute!
        deleted_rosters.each { |roster| STI::Deactivators::RosterDeactivator.new(roster_id, district_guid).execute! }
        inserted_rosters.each{ |roster| STI::Creators::RosterCreator.new(roster, district_guid).execute! }
      end

      private

      def deleted_rosters
        @data["Deleted"]
      end

      def inserted_rosters
        @data["Inserted"]
      end
    end
  end
end
