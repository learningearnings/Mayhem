class StudentOnboardCreditWorker
  include Sidekiq::Worker

  def perform(school_id)
    school = School.find(school_id)
    puts "School: #{school.name}"
    credit_manager=CreditManager.new
    teachers_count = teachers_to_pay(school).count
    if teachers_count > 0
      amount_per_teacher = prorated_amount / teachers_count
      amount_per_teacher = [amount_per_teacher, 1].max
      puts "Amount per Teacher: #{amount_per_teacher}"
      teachers_to_pay(school).each do |teacher|
        credit_manager.monthly_credits_for_onboarded_student_to_teacher school, teacher, amount_per_teacher
      end
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
