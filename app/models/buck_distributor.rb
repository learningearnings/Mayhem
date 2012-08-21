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
    700 * school.number_of_active_students
  end

  def handle_teachers
    @schools.each do |school|
      school.active_teachers.each do |teacher|
        pay_teacher(school, teacher)
      end
    end
  end

  def amount_for_teacher(school)
    school.balance / school.number_of_participating_teachers
  end

  def pay_teacher(school, teacher)
    @credit_manager.issue_credits_to_teacher school, teacher, amount_for_teacher(school)
  end
end
