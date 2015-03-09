load 'lib/sti/client.rb'
load 'lib/sti/importer.rb'
load 'lib/sti/async_importer.rb'
class StiImporterWorker
  include Sidekiq::Worker

  def perform(url, username, password, district_guid)

    sync_attempt = SyncAttempt.create(:district_guid => district_guid, :status => "Running")
    begin
      sti_client = STI::Client.new(base_url: url, username: username, password: password)
      district = District.where(guid: district_guid).first
      if district && district.has_current_versions?
        sti_importer = STI::AsyncImporter.new(client: sti_client, district_guid: district_guid)
        sync_attempt.students_response = sti_client.async_students(district.current_student_version).response.inspect
        sync_attempt.staff_response    = sti_client.async_staff(district.current_staff_version).response.inspect
        sync_attempt.sections_response = sti_client.async_sections(district.current_section_version).response.inspect
        sync_attempt.rosters_response  = sti_client.async_rosters(district.current_roster_version).response.inspect
        sync_attempt.schools_response  = sti_client.schools.response.inspect
      else
        sti_importer = STI::Importer.new(client: sti_client, district_guid: district_guid)
        sync_attempt.students_response = sti_client.students.response.inspect
        sync_attempt.staff_response    = sti_client.staff.response.inspect
        sync_attempt.sections_response = sti_client.sections.response.inspect
        sync_attempt.rosters_response  = sti_client.rosters.response.inspect
        sync_attempt.schools_response  = sti_client.schools.response.inspect
      end
      sti_importer.run!
      sync_attempt.status = "Success"
      sync_attempt.save
    rescue => e
      sync_attempt.error = e.inspect
      sync_attempt.backtrace = e.backtrace
      sync_attempt.status = "Failed"
      sync_attempt.save
    end
  end

  # We need to detect whether there are syncs for this district already running, if so we don't enqueue another one.
  def self.setup_sync(url, username, password, district_guid)
    workers = Sidekiq::Workers.new
    if Sidekiq::Queue.new(district_guid).size == 0 && !workers.detect {|w| w[1]["queue"] == district_guid }
      Sidekiq::Client.push('queue' => district_guid, 'class' => StiImporterWorker, 'args' => [url, username, password, district_guid])
      return true
    else
      return false
    end
  end
end
