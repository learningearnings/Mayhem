class BuckDistributor

  def initialize
    @schools = School.all
    @credit_manager = CreditManager.new
  end

  def run
    handle_schools
  end

  def handle_schools
    @schools.each do |school|
      @credit_manager.revoke_credits_for_school(school, school.main_account.balance)
      amount = 700 * school.active_students.count
      pay_school(school, amount)
    end
  end  

  def pay_school(school, amount)
    @credit_manager.issue_credits_to_school school, amount
  end

  def handle_teachers
    @schools.each do |school|
      school.active_teachers.each do |teacher|
        amount = (school.main_account.balance / school.active_teachers.count)
        pay_teacher(school, teacher, amount)
      end
  end

  def pay_teacher(school, teacher, amount)
    @credit_manager.issue_credits_to_teacher school, teacher, amount
  end

end
