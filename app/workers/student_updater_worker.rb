class StudentUpdaterWorker
  include Sidekiq::Worker

  def perform(students, school, action)
    @batch_student_updater = BatchStudentUpdater.new(students, school)
    @batch_student_updater.send(action)
  end

end
