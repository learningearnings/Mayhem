class StudentInterestWorker
  include Sidekiq::Worker

  def perform(admin=false, forced_run=false)
    StudentInterestHandler.new(admin, forced_run).run
  end

end
