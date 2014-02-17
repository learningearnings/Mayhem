load 'lib/sti/client.rb'
load 'lib/sti/importer.rb'
class StiImporterWorker
  include Sidekiq::Worker

  def perform(url, username, password, district_guid)
    sync_attempt = SyncAttempt.create(:district_guid => district_guid, :status => "Running")
    begin
      sti_client = STI::Client.new(:base_url => url, :username => username, :password => password, :district_guid => district_guid)
      sti_importer = STI::Importer.new :client => sti_client, :district_guid => district_guid
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
end
