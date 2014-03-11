class TeacherUpdaterWorker
  include Sidekiq::Worker

  def perform(teacher, teachers, school, action)
    if action == 'delete!'
      BatchTeacherUpdater.new(teachers, school).delete!
    else
      batch_teacher_updater = Proc.new{BatchTeacherUpdater.new(teachers, school).call}
      WorkerNotifier.new(teacher, action, &batch_teacher_updater).call
    end
  end

end
