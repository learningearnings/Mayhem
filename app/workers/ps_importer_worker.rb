class PSImporterWorker
  include Sidekiq::Worker

  def perform(district_guid)

    sync_attempt = SyncAttempt.create(:district_guid => district_guid, :status => "Running")
    begin
      slt = StiLinkToken.where(district_guid: district_guid).order(:status).first
      options = {}
      options["url"]  = slt.api_url
      options["id"]  = slt.link_key
      options["secret"] = slt.password 
      options['start_year'] = '2017'
      options["log_responses"] = false
      options["silence_logging"] = true
      options["import_dir"] = ""
      options['schools'] = [1,21,62] if district_guid == "903cd06f-623c-3909-a0e4-d503d57b8131"
      ps = PowerschoolImporter.new(options).run
      sync_attempt.status = "Success"
      sync_attempt.save
    rescue => e
      sync_attempt.error = e.inspect
      sync_attempt.backtrace = e.backtrace
      sync_attempt.status = "Failed"
      sync_attempt.save
    end

  end
  
  def save_sync_response_with_version(district, ps_client, sync_attempt_id)
    sync_attempt_response = SyncAttempt.find(sync_attempt_id)
    sync_attempt_response.save
  end
  # We need to detect whether there are syncs for this district already running, if so we don't enqueue another one.
  def self.setup_sync(district_guid)
    workers = Sidekiq::Workers.new
    if Sidekiq::Queue.new(district_guid).size == 0 && !workers.detect {|w| w[1]["queue"] == district_guid }
      Sidekiq::Client.push('queue' => district_guid, 'class' => PSImporterWorker, 'args' => [district_guid])
      return true
    else
      return false
    end
  end
end
