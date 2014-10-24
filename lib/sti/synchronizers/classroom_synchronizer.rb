module STI
  module Synchronizers
    class ClassroomSynchronizer
      def initialize(data, district_guid)
        @data = data
        @distict_guid = district_guid
      end

      def execute!
        deleted_classrooms.each { |classroom| STI::Deactivators::ClassroomDeactivator.new(classroom_id, district_guid).execute! }
        inserted_classrooms.each{ |classroom| STI::Creators::ClassroomCreator.new(classroom, district_guid).execute! }
        updated_classrooms.each { |classroom| STI::Updaters::ClassroomUpdater.new(classroom, district_guid).execute! }
      end
      
      private

      def deleted_classrooms
        @data["Deleted"]
      end

      def updated_classrooms
        @data["Updated"]
      end

      def inserted_classrooms
        @data["Inserted"]
      end
    end
  end
end
