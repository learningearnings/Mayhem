load 'lib/sti/creators/student_creator.rb'
load 'lib/sti/updaters/student_updater.rb'
load 'lib/sti/deactivators/student_deactivator.rb'
module STI
  module Synchronizers
    class StudentSynchronizer < BaseSynchronizer
      def execute!
        deleted.each { |student| STI::Deactivators::StudentDeactivator.new(student, @district_guid).execute! } if deleted
        inserted.each{ |student| STI::Creators::StudentCreator.new(student, @district_guid).execute! } if inserted
        updated.each { |student| STI::Updaters::StudentUpdater.new(student, @district_guid).execute! } if updated
        update_current_version(:current_student_version)
      end
    end
  end
end
