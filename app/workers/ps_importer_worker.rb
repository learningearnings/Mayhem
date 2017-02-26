class PSImporterWorker
  include Sidekiq::Worker

  def perform(district_guid)

    sync_attempt = SyncAttempt.create(:district_guid => district_guid, :status => "Running")
    begin
      slt = StiLinkToken.where(district_guid: district_guid).first
      options["url"]  = slt.api_url
      options["id"]  = slt.link_key
      options["secret"] = slt.password
      options["retries"] = 1
      options["import_dir"] = '/srv/'
      options['start_year'] = '2016'
      options['schools'] = [1,21,62]
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
