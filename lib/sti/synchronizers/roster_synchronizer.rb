load 'lib/sti/creators/roster_creator.rb'
load 'lib/sti/deactivators/roster_deactivator.rb'
module STI
  module Synchronizers
    class RosterSynchronizer < BaseSynchronizer
      def execute!
        deleted.each { |roster| STI::Deactivators::RosterDeactivator.new(roster, @district_guid).execute! } if deleted
        inserted.each{ |roster| STI::Creators::RosterCreator.new(roster, @district_guid).execute! } if inserted
        update_current_version(:current_roster_version)
      end
    end
  end
end
