class UserActivityDetailReportWorker
  include Sidekiq::Worker

  def perform(options={})
    Reports::Processors::NewUserActivityDetailReport.new(options).run
  end
end
