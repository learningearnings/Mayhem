class StudentUpdaterWorker
  include Sidekiq::Worker

  def perform(teacher, students, school_id, action)
    if action == 'delete!'
      BatchStudentUpdater.new(students, school_id).delete!
    else
      batch_student_updater = Proc.new{BatchStudentUpdater.new(students, school_id).call}
      WorkerNotifier.new(teacher, action, &batch_student_updater).call
    end
  end

end
