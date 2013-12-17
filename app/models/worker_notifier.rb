class WorkerNotifier

  def initialize(teacher, action, &block)
    @teacher = teacher
    @action = action
    @block = block
  end

  def call
    @block.send(@action.to_sym)
    UserMailer.bulk_update_notifier(@teacher)
  end
end
