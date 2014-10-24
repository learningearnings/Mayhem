module STI
  module Synchronizers
    class StudentSynchronizer < BaseSynchronizer
      def execute!
        deleted.each { |student| STI::Deactivators::StudentDeactivator.new(student, district_guid).execute! }
        inserted.each{ |student| STI::Creators::StudentCreator.new(student, district_guid).execute! }
        updated.each { |student| STI::Updaters::StudentUpdater.new(student, district_guid).execute! }
      end
    end
  end
end
