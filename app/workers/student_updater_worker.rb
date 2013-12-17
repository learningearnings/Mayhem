class StudentUpdaterWorker
  include Sidekiq::Worker

  def perform(teacher, students, school, action)
    batch_student_updater = Proc.new{BatchStudentUpdater.new(students, school).call}
    WorkerNotifier.new(teacher, action, &batch_student_updater).call
  end

end
