class UserActivitySummaryReportWorker
  include Sidekiq::Worker

  def perform(options={})
    Reports::Processors::NewUserActivitySummaryReport.new(options).run
  end
end
