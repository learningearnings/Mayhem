class UserActivityReportWorker
  include Sidekiq::Worker

  def perform(options={})
    Reports::Processors::NewUserActivityReport.new(options).run
  end
end
