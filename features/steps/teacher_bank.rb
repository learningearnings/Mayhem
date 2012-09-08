class TeacherBank < Spinach::FeatureSteps
  include SharedSteps

  Then 'the teacher account should be deducted' do
    @teacher.main_account(@school).balance == BigDecimal.new('9984.00')
    @teacher.unredeemed_account(@school).balance == BigDecimal.new('16.00')
  end
end
