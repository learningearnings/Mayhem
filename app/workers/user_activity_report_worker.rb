class DelayedReportWorker
  include Sidekiq::Worker

  def perform
    require 'rake'
    Leror::Application.load_tasks 
    Rake::Task['le:user_activity_report'].invoke
  end
end
