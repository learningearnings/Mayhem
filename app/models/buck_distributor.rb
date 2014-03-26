class BuckDistributor
  extend ActiveSupport::Memoizable
  DAILY_STUDENT_AMOUNT = 25

  def initialize(schools=School.all, credit_manager=CreditManager.new)
    @schools = schools
    @credit_manager = credit_manager
  end

  def run
    handle_schools
    handle_teachers
  end

  def handle_schools
    @schools.each do |school|
      @credit_manager.revoke_credits_for_school(school, school.balance)
      pay_school(school)
    end
  end

  def pay_school(school)
    @credit_manager.issue_credits_to_school school, amount_for_school(school)
  end

  # 25 dollars per student per day
  def amount_for_school school
    days_in_month = Time.days_in_month(Time.now.month)
    days_left_in_month = (days_in_month - Time.now.day) + 1
    DAILY_STUDENT_AMOUNT * days_left_in_month * active_students(school).count
  end
  memoize :amount_for_school

  def handle_teachers
    @schools.each do |school|
      teachers_to_pay(school).each do |teacher|
        revoke_remainder(school, teacher, teacher.main_account(school).balance)
        pay_teacher(school, teacher)
      end
    end
  end

  def revoke_remainder(school, teacher, amount)
    @credit_manager.revoke_credits_for_teacher(school, teacher, amount)
  end

  def amount_for_teacher(school)
    amount_for_school(school) / teachers_to_pay(school).count
  end
  memoize :amount_for_teacher

  def teachers_to_pay(school)
    (school.teachers.recently_logged_in + school.teachers.recently_created).uniq
  end
  memoize :teachers_to_pay

  def active_students(school)
    (school.students.recently_logged_in + school.students.recently_created).uniq
  end
  memoize :active_students

  def pay_teacher(school, teacher)
    @credit_manager.monthly_credits_to_teacher school, teacher, amount_for_teacher(school)
  end
end
