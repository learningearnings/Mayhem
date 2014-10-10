class StudentUpdaterWorker
  include Sidekiq::Worker

  def perform(email, students, school_id, action)
    if action == 'delete!'
      BatchStudentUpdater.new(students, school_id).delete!
    else
      batch_student_updater = Proc.new{BatchStudentUpdater.new(students, school_id).call}
      WorkerNotifier.new(email, action, &batch_student_updater).call
    end
  end

end
