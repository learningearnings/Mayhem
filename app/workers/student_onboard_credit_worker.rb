class StudentOnboardCreditWorker
  include Sidekiq::Worker

  def perform(school_id)
    school = School.find(school_id)
    puts "School: #{school.name}"
    credit_manager=CreditManager.new
    amount_per_teacher = prorated_amount / school.teachers.recently_logged_in.count
    puts "Amount per Teacher: #{amount_per_teacher}"
    school.teachers.recently_logged_in.each do |teacher|
      credit_manager.monthly_credits_for_onboarded_student_to_teacher school, teacher, amount_per_teacher
    end
  end

  def prorated_amount
    days_in_month = Time.days_in_month(Time.now.month)
    days_left_in_month = (days_in_month - Time.now.day) + 1
    BuckDistributor::DAILY_STUDENT_AMOUNT * days_left_in_month
  end
end
