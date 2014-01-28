load 'lib/sti/client.rb'
load 'lib/sti/importer.rb'
class StiImporterWorker
  include Sidekiq::Worker

  def perform(url, username, password, district_guid)
    sti_client = STI::Client.new(:base_url => url, :username => username, :password => password, :district_guid => district_guid)
    sti_importer = STI::Importer.new :client => sti_client, :district_guid => district_guid
    sti_importer.run!
  end
end
