# This class should be called like so:
#   sti_link_token = StiLinkToken.first
#   client = STI::Client.new(base_url: sti_link_token.api_url, username: sti_link_token.username, password: sti_link_token.password)
#   STI::AsyncImporter.new(client: client, district_guid: sti_link_token.district_guid).run!

load 'lib/sti/client.rb'
load 'lib/sti/synchronizers/base_synchronizer.rb'
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

    def run!
      district = District.where(guid: @district_guid).first

      ##### Update Schools ######
      sti_schools = client.schools.parsed_response
      puts sti_schools
      school_synchronizer = STI::Synchronizers::SchoolSynchronizer.new(sti_schools || [], @district_guid)
      school_synchronizer.execute!

      ##### Update Staff #####
      staff_response = client.async_staff(district.current_staff_version).parsed_response
      puts staff_response
      staff_synchronizer = STI::Synchronizers::StaffSynchronizer.new(staff_response || [], @district_guid)
      staff_synchronizer.execute!

      ##### Update Classrooms #####
      section_response = client.async_sections(district.current_section_version).parsed_response
      puts section_response
      classroom_synchronizer = STI::Synchronizers::ClassroomSynchronizer.new(section_response || [], @district_guid)
      classroom_synchronizer.execute!

      ##### Update Students #####
      student_response = client.async_students(district.current_student_version).parsed_response
      puts student_response
      student_synchronizer = STI::Synchronizers::StudentSynchronizer.new(student_response || [], @district_guid)
      student_synchronizer.execute!

      ##### Update Rosters #####
      roster_response = client.async_rosters(district.current_roster_version).parsed_response
      puts roster_response
      roster_synchronizer = STI::Synchronizers::RosterSynchronizer.new(roster_response || [], @district_guid)
      roster_synchronizer.execute!

      ##### Update API #####
      newly_synced_schools = sti_schools.select {|school| school["IsSyncComplete"] != true}.map{|school| School.where(:district_guid => @district_guid, :sti_id => school["Id"]).first }
      #BuckDistributor.new(newly_synced_schools).run

      newly_synced_schools.each do |school|
        #request = client.set_school_synced(school.sti_id)
        raise "Couldn't set school synced got: #{request.response.inspect}" if request.response.code != "204"
      end
    end

    private

    def client
      @client ||= Client.new
    end
  end
end
