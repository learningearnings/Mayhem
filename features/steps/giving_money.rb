class GivingCredits < Spinach::FeatureSteps
  Given 'the main account exists' do
    Plutus::Liability.create(name: CreditManager.new.main_account_name)
  end

  When 'a school exists with credits' do
    @school = FactoryGirl.create(:school)
    @credits = 20_000
    cm = CreditManager.new
    cm.issue_credits_to_school(@school, @credits)
  end

  And 'I take away all of the schools credits' do
    cm = CreditManager.new
    cm.revoke_credits_for_school(@school, @credits)
  end

  Then 'that school should have some credits' do
    @school.balance.wont_equal 0
  end

  Then 'that school should have 0 credits' do
    @school.balance.must_equal 0
  end

  When 'a school exists with a student' do
    @school = FactoryGirl.create(:school)
    @student = FactoryGirl.create(:student)
    @link = FactoryGirl.create(:person_school_link, school: @school, person: @student)
  end

  And 'I give a school 10000 credits' do
    @credits = 10_000
    cm = CreditManager.new
    cm.issue_credits_to_school(@school, @credits)
  end

  Then 'that school should have 10000 credits' do
    @school.balance.must_equal BigDecimal("10000")
  end

  Then 'that teacher should have 1000 credits to give' do
    @teacher.main_account(@school).balance.must_equal BigDecimal('1000')
  end

  And 'the school should have 9000 credits to give' do
    @school.balance.must_equal BigDecimal('9000')
  end

  Given 'I am a teacher at a school with students' do
    @school = FactoryGirl.create(:school)
    @student1 = FactoryGirl.create(:student)
    @link1 = FactoryGirl.create(:person_school_link, school: @school, person: @student1)
    @student2 = FactoryGirl.create(:student)
    @link2 = FactoryGirl.create(:person_school_link, school: @school, person: @student2)
    @teacher = FactoryGirl.create(:teacher)
    @teacher_link = FactoryGirl.create(:person_school_link, school: @school, person: @teacher)
  end

  When 'I have 1000 credits to give' do
    @credits = 1000
    cm = CreditManager.new
    cm.issue_credits_to_school(@school, @credits)
    cm.issue_credits_to_teacher(@school, @teacher, @credits)
  end

  And 'I give a student 10 credits' do
    @student_credits = 10
    cm = CreditManager.new
    cm.issue_credits_to_student(@school, @teacher, @student1, @student_credits)
  end

  Then 'I should have 990 credits' do
    @teacher.main_account(@school).balance.must_equal BigDecimal('990')
  end

  And 'I give 2 students 5 credits each' do
    @student_credits = 5
    cm = CreditManager.new
    cm.issue_credits_to_student(@school, @teacher, @student1, @student_credits)
    cm.issue_credits_to_student(@school, @teacher, @student2, @student_credits)
  end

  When 'I have 100 credits' do
    @student_credits = 100
    cm = CreditManager.new
    cm.issue_credits_to_student(@school, @teacher, @student, @student_credits)
  end

  And 'I purchase a reward that cost 5 credits' do
    cm = CreditManager.new
    cm.transfer_credits_for_reward_purchase(@student, BigDecimal('5'))
  end

  And 'I attempt to purchase a reward that costs 105 credits' do
    cm = CreditManager.new
    cm.transfer_credits_for_reward_purchase(@student, BigDecimal('105'))
  end

  Then 'I should have 100 credits' do
    @student.balance.must_equal BigDecimal('100')
  end

  Then 'I should have 95 credits' do
    @student.balance.must_equal BigDecimal('95')
  end

  When 'the school gives a teacher 1000 credits' do
    @teacher = FactoryGirl.create(:teacher)
    @teacher_credits = 1_000
    @teacher_link = FactoryGirl.create(:person_school_link, school: @school, person: @teacher)
    cm = CreditManager.new
    cm.issue_credits_to_teacher(@school, @teacher, @teacher_credits)
  end

  Given 'a school has 10000 credits to give' do
    @school = FactoryGirl.create(:school)
    @credits = 10_000
    cm = CreditManager.new
    cm.issue_credits_to_school(@school, @credits)
  end

  Given 'I am a student' do
    @school = FactoryGirl.create(:school)
    @student = FactoryGirl.create(:student)
    @link = FactoryGirl.create(:person_school_link, school: @school, person: @student)
    @teacher = FactoryGirl.create(:teacher)
    @teacher_link = FactoryGirl.create(:person_school_link, school: @school, person: @teacher)
  end

  And 'I transfer 45 credits to savings' do
    cm = CreditManager.new
    cm.transfer_credits_from_checking_to_savings(@student, BigDecimal('45'))
  end

  And 'I transfer 35 credits to checking' do
    cm = CreditManager.new
    cm.transfer_credits_from_savings_to_checking(@student, BigDecimal('35'))
  end

  Then 'I should have 45 credits in savings' do
    @student.savings_balance.must_equal BigDecimal('45')
  end

  Then 'I should have 55 credits in checking' do
    @student.checking_balance.must_equal BigDecimal('55')
  end

  Then 'I should have 10 credits in savings' do
    @student.savings_balance.must_equal BigDecimal('10')
  end

  Then 'I should have 90 credits in checking' do
    @student.checking_balance.must_equal BigDecimal('90')
  end
end
