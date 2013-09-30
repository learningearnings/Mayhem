class StudentBank < Spinach::FeatureSteps
  include SharedSteps
  include ActionView::Helpers::UrlHelper

  Then 'the teacher unredeemed account should be deducted' do
    @teacher.main_account(@school).balance.must_equal BigDecimal.new('9984.00')
    @teacher.unredeemed_account(@school).balance.must_equal BigDecimal.new('16.00')
  end

  Then 'the student account should receive bucks' do 
    @student1.checking_account.balance.must_equal BigDecimal.new('5.00')
  end

  Then 'I enter the code' do
    fill_in 'code', :with => @code
    click_button 'Redeem'
  end

  Given 'I have a printed buck\'s code' do
    bank = Bank.new
    bank.create_print_bucks(@teacher, @school, 'AL', { ones: 0, fives: 1, tens: 0 })
    @code = OtuCode.last.code
  end

  Given 'a teacher has sent me some ebucks' do
    bank = Bank.new
    bank.create_ebucks(@teacher, @school, @student1, 'AL', 5)
  end

  Given 'I claim bucks from a buck message' do
    click_link 'Claim Bucks'
  end
end
