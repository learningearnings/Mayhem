class GivingCredits < Spinach::FeatureSteps
  Given 'the main account exists' do
    Plutus::Liability.create(name: CreditManager.new.main_account_name)
  end

  Given 'I am an administrator' do
    pending 'step not implemented'
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
    pending 'step not implemented'
  end

  And 'I give a school 10000 credits' do
    pending 'step not implemented'
  end

  Then 'that school should have 10000 credits' do
    pending 'step not implemented'
  end

  And 'I have 10000 credits to give' do
    pending 'step not implemented'
  end

  And 'I give a teacher 1000 credits' do
    pending 'step not implemented'
  end

  Then 'that teacher should have 1000 credits to give' do
    pending 'step not implemented'
  end

  And 'I should have 9000 credits to give' do
    pending 'step not implemented'
  end

  When 'I have 1000 credits to give' do
    pending 'step not implemented'
  end

  And 'I give a student 10 credits' do
    pending 'step not implemented'
  end

  Then 'I should have 990 credits' do
    pending 'step not implemented'
  end

  And 'I give 2 students 5 credits each' do
    pending 'step not implemented'
  end

  When 'I have 100 credits' do
    pending 'step not implemented'
  end

  And 'I purchase a reward that cost 5 credits' do
    pending 'step not implemented'
  end

  Then 'I should have 95 credits' do
    pending 'step not implemented'
  end

  Given 'a school has 10000 credits to give' do
    pending 'step not implemented'
  end
end
