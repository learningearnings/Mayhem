load 'lib/sti/creators/staff_creator.rb'
load 'lib/sti/updaters/staff_updater.rb'
load 'lib/sti/deactivators/staff_deactivator.rb'
module STI
  module Synchronizers
    class StaffSynchronizer < BaseSynchronizer
    	def execute!
        puts "-----------------------------"
        puts deleted.inspect
        puts "-----------------------------"
        puts inserted.inspect
        puts "-----------------------------"
        puts updated.inspect
        # deleted.each { |member| STI::Deactivators::StaffDeactivator.new(member, @district_guid).execute! } if deleted
        # inserted.each{ |member| STI::Creators::StaffCreator.new(member, @district_guid).execute! } if inserted
        # updated.each { |member| STI::Updaters::StaffUpdater.new(member, @district_guid).execute! } if updated
        # update_current_version(:current_staff_version)
      end
    end
  end
end
