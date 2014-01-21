class BuckDistributor
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

  def amount_for_school school
    700 * school.students.logged.count
  end

  def handle_teachers
    @schools.each do |school|
      school.teachers.logged.each do |teacher|
        revoke_remainder(school, teacher, teacher.main_account(school).balance)
        pay_teacher(school, teacher)
      end
    end
  end

  def revoke_remainder(school, teacher, amount)
    @credit_manager.revoke_credits_for_teacher(school, teacher, amount)
  end

  def amount_for_teacher(school)
    school.balance / school.teachers.logged.count
  end

  def pay_teacher(school, teacher)
    @credit_manager.monthly_credits_to_teacher school, teacher, amount_for_teacher(school)
  end
end
