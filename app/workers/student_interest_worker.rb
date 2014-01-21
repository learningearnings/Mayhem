class StudentInterestWorker
  include Sidekiq::Worker

  def perform(admin=false, forced_run=false)
    interest_handler = Proc.new{StudentInterestHandler.new(admin, forced_run).call}
    WorkerNotifier.new(admin.email, action, &interest_handler).call
  end

end
