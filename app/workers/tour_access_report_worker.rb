class TourAccessReportWorker
  include Sidekiq::Worker

  def perform(options={})
    Reports::Processors::NewTourAccessReport.new(options).run
  end
end
