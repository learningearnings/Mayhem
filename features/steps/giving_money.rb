class GivingCredits < Spinach::FeatureSteps
  include SharedSteps

  When 'a school exists with credits' do
    @school = FactoryGirl.create(:school)
    @credits = 20_000
    cm = CreditManager.new
    cm.issue_credits_to_school(@school, @credits)
    # Issuing credits to a school draws down the main account to a negative, but
    # equivalent, balance
    cm.main_account.balance.must_equal(@credits)
  end

  When 'I take away all of the schools credits' do
    cm = CreditManager.new
    cm.revoke_credits_for_school(@school, @credits)
  end

  Then 'the main LE account should have the amount of credits taken away' do
    cm = CreditManager.new
    # It will equal zero in the case, because it will have already been given a
    # negative balance when first issuing credits to the school with a zero
    # balance.
    cm.main_account.balance.must_equal(0)
  end

  Then 'that school should have some credits' do
    refresh_school_accounts(@school)
    @school.balance.wont_equal 0
  end

  Then 'that school should have 0 credits' do
    refresh_school_accounts(@school)
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

  Then 'the main LE account should have 10000 credits less' do
    CreditManager.new.main_account.balance.must_equal(BigDecimal('10000'))
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
    @school_admin = FactoryGirl.create(:school_admin)
    @admin_link = FactoryGirl.create(:person_school_link, school: @school, person: @school_admin)
    @teacher = FactoryGirl.create(:teacher)
    @teacher_link = FactoryGirl.create(:person_school_link, school: @school, person: @teacher)
  end

  When 'I have 1000 credits to give' do
    @credits = 1000
    cm = CreditManager.new
    cm.issue_credits_to_school(@school, @credits)
    cm.issue_credits_to_teacher(@school, @teacher, @credits)
    cm.issue_credits_to_teacher(@school, @school_admin, @credits)
  end

  And 'I give a student 10 credits' do
    @student_credits = 10
    cm = CreditManager.new
    # Teacher purchases the credits
    cm.purchase_ebucks(@school, @teacher, @student1, @student_credits)
    # Student redeems the credits
    cm.issue_ecredits_to_student(@school, @teacher, @student1, @student_credits)
  end

  Then 'I should have 990 credits' do
    @teacher.main_account(@school).balance.must_equal BigDecimal('990')
  end

  And 'the student should have 10 credits in checking' do
    @student1.checking_account.balance.must_equal BigDecimal('10')
  end

  And 'the first student should have 5 credits in checking' do
    @student1.checking_account.balance.must_equal BigDecimal('5')
  end

  And 'the second student should have 5 credits in checking' do
    @student2.checking_account.balance.must_equal BigDecimal('5')
  end

  And 'I give 2 students 5 credits each' do
    @student_credits = 5
    cm = CreditManager.new
    [@student1, @student2].each do |student|
      # Teacher purchases the credits
      cm.purchase_ebucks(@school, @teacher, student, @student_credits)
      # Student redeems the credits
      cm.issue_ecredits_to_student(@school, @teacher, student, @student_credits)
    end
  end

  When 'I have 100 credits' do
    @student_credits = 100
    cm = CreditManager.new
    cm.issue_ecredits_to_student(@school, @teacher, @student, @student_credits)
  end

  And 'I purchase a reward that cost 5 credits' do
    cm = CreditManager.new
    cm.transfer_credits_for_reward_purchase(@student, BigDecimal('5'))
    refresh_student_accounts(@student)
  end

  Then 'I should have 95 credits in checking' do
    @student.checking_account.balance.must_equal BigDecimal('95')
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

  And 'a teacher is a member of that school' do
    @teacher = FactoryGirl.create(:teacher)
    @teacher_link = FactoryGirl.create(:person_school_link, school: @school, person: @teacher)
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
    refresh_student_accounts(@student)
  end

  And 'I transfer 10 credits to savings' do
    cm = CreditManager.new
    cm.transfer_credits_from_checking_to_savings(@student, BigDecimal('10'))
    refresh_student_accounts(@student)
  end

  And 'I transfer 35 credits to checking' do
    cm = CreditManager.new
    cm.transfer_credits_from_savings_to_checking(@student, BigDecimal('35'))
    refresh_student_accounts(@student)
  end

  And 'I transfer 5 credits to checking' do
    cm = CreditManager.new
    cm.transfer_credits_from_savings_to_checking(@student, BigDecimal('5'))
    refresh_student_accounts(@student)
  end

  Then 'I should have 45 credits in savings' do
    @student.savings_balance.must_equal BigDecimal('45')
  end

  Then 'I should have 55 credits in checking' do
    @student.checking_balance.must_equal BigDecimal('55')
  end

  Then 'I should have 5 credits in checking' do
    @student.checking_balance.must_equal BigDecimal('5')
  end

  Then 'I should have 190 credits in checking' do
    @student.checking_balance.must_equal BigDecimal('190')
  end

  Then 'I should have 10 credits in savings' do
    @student.savings_balance.must_equal BigDecimal('10')
  end

  Then 'I should have 90 credits in checking' do
    @student.checking_balance.must_equal BigDecimal('90')
  end

  Then 'I should have 100 credits in checking' do
    @student.checking_balance.must_equal BigDecimal('100')
  end

  Then 'I should have 50 credits total' do
    (@student.checking_balance + @student.savings_balance).must_equal BigDecimal('50')
  end

  When 'I have 200 credits in checking' do
    @student_credits = 200
    cm = CreditManager.new
    cm.issue_ecredits_to_student(@school, @teacher, @student, @student_credits)
  end

  When 'I have 100 credits in checking' do
    @student_credits = 100
    cm = CreditManager.new
    cm.issue_ecredits_to_student(@school, @teacher, @student, @student_credits)
  end

  When 'I have 50 credits in savings' do
    @student_credits = 50
    cm = CreditManager.new
    cm.issue_ecredits_to_student(@school, @teacher, @student, @student_credits)
    cm.transfer_credits_from_checking_to_savings(@student, @student_credits)
    refresh_student_accounts(@student)
  end

  # This is necessary due to the account caching that's now in place
  def refresh_student_accounts student
    student.checking_account.reload
    student.savings_account.reload
  end

  def refresh_school_accounts school
    school.main_account.reload
  end
end
