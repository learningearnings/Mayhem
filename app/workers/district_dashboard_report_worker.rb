class DistrictDashboardReportWorker
  include Sidekiq::Worker

  def perform(options={})
    Reports::Processors::NewDistrictDashboardReport.new(options).run
  end
end
