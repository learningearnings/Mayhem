class TeacherUpdaterWorker
  include Sidekiq::Worker

  def perform(email, teachers, school_id, action, current_person)
    if action == 'delete!'
      BatchTeacherUpdater.new(teachers, school_id,current_person).delete!
    else
      batch_teacher_updater = Proc.new{BatchTeacherUpdater.new(teachers, school_id,current_person).call}
      WorkerNotifier.new(email, action, &batch_teacher_updater).call
    end
  end

end
