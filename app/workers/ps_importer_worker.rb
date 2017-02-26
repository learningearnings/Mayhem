class PSImporterWorker
  include Sidekiq::Worker

  def perform(district_guid)

    sync_attempt = SyncAttempt.create(:district_guid => district_guid, :status => "Running")
    begin
      #slt = StiLinkToken.where(district_guid: district_guid).first
      options = {}
      if district_guid == "903cd06f-623c-3909-a0e4-d503d57b8131"
        options["url"]  = 'https://powerschool.hcde.org'
        options["id"]  = '8bb3e9cc-ccd3-44c4-91b3-1d1ebaa19feb'
        options["secret"] = 'c233dc29-3e66-4109-986b-c92110fe3505'
        options["retries"] = 1
        options["import_dir"] = '/srv/'
        options['start_year'] = '2016'
        options['schools'] = [1,21,62]
      else
        options["url"]  = 'https://rw3wtqualapp493.powerschool.com'
        options["id"]  = '4b09bd84-64a6-4488-a8fb-96401925772c'
        options["secret"] = 'bf6e327e-79af-4d7f-b83e-8f7fa42240c4'
        options["retries"] = 1
        options["import_dir"] = '/srv/'
        options['start_year'] = '2016'       
      end
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
