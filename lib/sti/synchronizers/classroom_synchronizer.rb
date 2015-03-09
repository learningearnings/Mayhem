load 'lib/sti/creators/classroom_creator.rb'
load 'lib/sti/updaters/classroom_updater.rb'
load 'lib/sti/deactivators/classroom_deactivator.rb'
module STI
  module Synchronizers
    class ClassroomSynchronizer < BaseSynchronizer
      def execute!
        deleted.each { |classroom| STI::Deactivators::ClassroomDeactivator.new(classroom, @district_guid).execute! }
        inserted.each{ |classroom| STI::Creators::ClassroomCreator.new(classroom, @district_guid).execute! }
        updated.each { |classroom| STI::Updaters::ClassroomUpdater.new(classroom, @district_guid).execute! }
        update_current_version(:current_section_version)
      end
    end
  end
end
