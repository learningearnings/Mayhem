class TeacherCreditUpdaterWorker
  include Sidekiq::Worker
  def perform(teachers, school,credit_amount, action)
    if action == "Add Credits"
      batch_teacher_credit_updater = Proc.new{BatchTeacherUpdater.new(teachers, school, credit_amount).call}
    else
    end 	
  end
end
