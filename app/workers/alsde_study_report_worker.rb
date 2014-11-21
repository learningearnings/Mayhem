class ALSDEStudyReportWorker
  include Sidekiq::Worker

  def perform(options={})
    Reports::Processors::ALSDEStudy.new(options).run
  end
end
