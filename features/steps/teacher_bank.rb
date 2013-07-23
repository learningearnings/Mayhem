class TeacherBank < Spinach::FeatureSteps
  include SharedSteps

  Given 'I am authorized to distribute credits' do
    @teacher.update_attributes({ can_distribute_credits: true }, as: :admin)
  end

  Then 'the teacher account should be deducted' do
    @teacher.main_account(@school).balance.must_equal BigDecimal.new('984.00')
    @teacher.unredeemed_account(@school).balance.must_equal BigDecimal.new('16.00')
  end

  Then 'the teacher account should be deducted for ebucks' do
    @teacher.main_account(@school).balance.must_equal BigDecimal.new('984.00')
    @teacher.undeposited_account(@school).balance.must_equal BigDecimal.new('16.00')
  end

  Then 'I should not see the option to distribute printed bucks' do
    page.has_content?(physical_credits_heading).must_equal false
  end

  Then 'I should not see the option to distribute ebucks' do
    page.has_content?(ebucks_heading).must_equal false
  end

  def physical_credits_heading
    "Print Physical Credits"
  end

  def ebucks_heading
    "Create E-Credits"
  end
end
