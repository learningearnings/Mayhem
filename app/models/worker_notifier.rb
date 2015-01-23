class WorkerNotifier

  def initialize(email, action, &block)
    @email = email
    @action = action
    @block = block
  end

  def call
    @block.send(@action.to_sym)
    UserMailer.bulk_update_notifier(@email).deliver
  end

end
