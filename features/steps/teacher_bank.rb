class TeacherBank < Spinach::FeatureSteps
  include SharedSteps

  Then 'the teacher account should be deducted' do
    @teacher.main_account(@school).balance.must_equal BigDecimal.new('984.00')
    @teacher.unredeemed_account(@school).balance.must_equal BigDecimal.new('16.00')
  end

  Then 'the teacher account should be deducted for ebucks' do
    @teacher.main_account(@school).balance.must_equal BigDecimal.new('984.00')
    @teacher.undeposited_account(@school).balance.must_equal BigDecimal.new('16.00')
  end
end
