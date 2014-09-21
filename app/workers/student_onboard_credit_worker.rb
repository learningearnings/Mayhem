class StudentOnboardCreditWorker
  include Sidekiq::Worker

  def perform(school_id)
    school = School.find(school_id)
    teachers_to_pay_for_school = teachers_to_pay(school)
    return false if teachers_to_pay_for_school.blank?
    credit_manager = CreditManager.new
    amount_per_teacher = prorated_amount / teachers_to_pay_for_school.count
    amount_per_teacher = [amount_per_teacher, 1].max
    teachers_to_pay_for_school.each do |teacher|
      credit_manager.monthly_credits_for_onboarded_student_to_teacher school, teacher, amount_per_teacher
    end
  end

  def teachers_to_pay(school)
    (school.teachers.recently_logged_in + school.teachers.recently_created).uniq
  end

  def prorated_amount
    days_in_month = Time.days_in_month(Time.now.month)
    days_left_in_month = (days_in_month - Time.now.day) + 1
    BuckDistributor::DAILY_STUDENT_AMOUNT * days_left_in_month
  end
end
