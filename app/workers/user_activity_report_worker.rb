class UserActivityReportWorker
  include Sidekiq::Worker

  def perform(options={})
    Reports::Processors::NewUserActivityReport.new(options,current_user).run
  end
end
