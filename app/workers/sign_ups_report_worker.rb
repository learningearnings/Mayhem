class SignUpsReportWorker
  include Sidekiq::Worker

  def perform(options={})
    Reports::Processors::SignUpsReport.new(options).run
  end
end
