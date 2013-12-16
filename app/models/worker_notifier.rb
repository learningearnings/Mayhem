class WorkerNotifier

  def initialize(teacher, action, &block)
    @action = action
    @block = block
  end

  def call
    @block.send(@action)
    Rails.logger.info('--------------------------------------Update has finished!-----------------------------------------')
    UserMailer.bulk_update_notifier(teacher)
  end
end
