class StudentInterestWorker
  include Sidekiq::Worker

  def perform(admin=nil, forced_run=nil)
    action = 'call'
    interest_handler = Proc.new{StudentInterestHandler.new(admin, forced_run).call}
    WorkerNotifier.new(admin, action, &interest_handler).call
  end

end
