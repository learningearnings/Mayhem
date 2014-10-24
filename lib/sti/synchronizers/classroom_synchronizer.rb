module STI
  module Synchronizers
    class ClassroomSynchronizer < BaseSynchronizer
      def execute!
        deleted.each { |classroom| STI::Deactivators::ClassroomDeactivator.new(classroom_id, district_guid).execute! }
        inserted.each{ |classroom| STI::Creators::ClassroomCreator.new(classroom, district_guid).execute! }
        updated.each { |classroom| STI::Updaters::ClassroomUpdater.new(classroom, district_guid).execute! }
      end
    end
  end
end
