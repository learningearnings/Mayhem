class BuckDistributor
  def initialize(schools=School.all, credit_manager=CreditManager.new, should_prorate=false)
    @schools = schools
    @credit_manager = credit_manager
    @should_prorate = should_prorate
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

  def amount_for_school school
    initial_amount = 700 * school.students.recently_logged_in.count
    if @should_prorate
      days_in_month = Time.days_in_month(Time.now.month)
      daily_amount = BigDecimal(initial_amount) / BigDecimal(days_in_month)
      days_left_in_month = (days_in_month - Time.now.day) + 1
      prorated_amount = (days_left_in_month * daily_amount).round(0, :up).to_i
    end
    @should_prorate ? prorated_amount : initial_amount
  end

  def handle_teachers
    @schools.each do |school|
      school.teachers.recently_logged_in.each do |teacher|
        revoke_remainder(school, teacher, teacher.main_account(school).balance)
        pay_teacher(school, teacher)
      end
    end
  end

  def revoke_remainder(school, teacher, amount)
    @credit_manager.revoke_credits_for_teacher(school, teacher, amount)
  end

  def amount_for_teacher(school)
    school.balance / school.teachers.recently_logged_in.count
  end

  def pay_teacher(school, teacher)
    @credit_manager.monthly_credits_to_teacher school, teacher, amount_for_teacher(school)
  end
end
