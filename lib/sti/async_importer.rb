# This class should be called like so:
#   STI::AsyncImporter.new(district_guid: district_guid).execute!

load 'lib/sti/client.rb'
load 'lib/sti/synchronizers/staff_synchronizer.rb'
load 'lib/sti/synchronizers/roster_synchronizer.rb'
load 'lib/sti/synchronizers/school_synchronizer.rb'
load 'lib/sti/synchronizers/student_synchronizer.rb'
load 'lib/sti/synchronizers/classroom_synchronizer.rb'
module STI
  class AsyncImporter
    def initialize(options={})
      @client =        options[:client]
      @district_guid = options[:district_guid]
    end

    def execute!
      ##### Update Schools ######
      sti_schools = client.schools.parsed_response
      school_synchronizer = STI::Synchronizers::SchoolSynchronizer.new(sti_schools, @district_guid)
      school_synchronizer.execute!

      ##### Update Staff #####
      staff_synchronizer = STI::Synchronizers::StaffSynchronizer.new(client.async_staff.parsed_response, @district_guid)
      staff_synchronizer.execute!

      ##### Update Classrooms #####
      classroom_synchronizer = STI::Synchronizers::ClassroomSynchronizer.new(client.async_sections.parsed_response, @district_guid)
      classroom_synchronizer.execute!

      ##### Update Students #####
      student_synchronizer = STI::Synchronizers::StudentSynchronizer.new(client.async_students.parsed_response, @district_guid)
      student_synchronizer.execute!

      ##### Update Rosters #####
      roster_synchronizer = STI::Synchronizers::RosterSynchronizer.new(client.async_rosters.parsed_response, @district_guid)
      roster_synchronizer.execute!

      ##### Update API #####
      newly_synced_schools = sti_schools.select {|school| school["IsSyncComplete"] != true}.map{|school| School.where(:district_guid => @district_guid, :sti_id => school["Id"]).first }
      BuckDistributor.new(newly_synced_schools).run

      newly_synced_schools.each do |school|
        request = client.set_school_synced(school.sti_id)
        raise "Couldn't set school synced got: #{request.response.inspect}" if request.response.code != "204"
      end
    end

    private

    def client
      @client ||= Client.new
    end
  end
end
