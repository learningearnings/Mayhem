load 'lib/sti/client.rb'
load 'lib/sti/importer.rb'
class StiImporterWorker
  include Sidekiq::Worker

  def perform(url, username, password)
    sti_client = STI::Client.new(:base_url => url, :username => username, :password => password)
    sti_importer = STI::Importer.new :client => sti_client
    sti_importer.run!
  end
end
