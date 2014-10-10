class TeacherUpdaterWorker
  include Sidekiq::Worker

  def perform(email, teachers, school_id, action)
    if action == 'delete!'
      BatchTeacherUpdater.new(teachers, school_id).delete!
    else
      batch_teacher_updater = Proc.new{BatchTeacherUpdater.new(teachers, school_id).call}
      WorkerNotifier.new(email, action, &batch_teacher_updater).call
    end
  end

end
