module STI
  module Synchronizers
    class StudentSynchronizer
      def initialize(data, district_guid)
        raise ArgumentError, 'data must be given.' unless data.present? && district_guid.present?
        @data = data
        @district_guid = district_guid
      end

      def execute!
        deleted_students.each { |student| STI::Deactivators::StudentDeactivator.new(student, district_guid).execute! }
        inserted_students.each{ |student| STI::Creators::StudentCreator.new(student, district_guid).execute! }
        updated_students.each { |student| STI::Updaters::StudentUpdater.new(student, district_guid).execute! }
      end

      private

      def deleted_students
        @data["Deleted"]
      end

      def updated_students
        @data["Updated"]
      end

      def inserted_students
        @data["Inserted"]
      end
    end
  end
end
