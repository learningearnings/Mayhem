class AdminBank < Spinach::FeatureSteps
  include SharedSteps

  Given 'I distribute bucks for a teacher' do
    select @teacher.name, :from => 'teacher_id'
    fill_in 'point1', :with => '1'
    fill_in 'point5', :with => '1'
    fill_in 'point10', :with => '1'
    click_button 'Print Bucks'
  end

  Then 'the admin account should be deducted' do
    @school_admin.main_account(@school).balance == BigDecimal.new('9984.00')
    @school_admin.unredeemed_account(@school).balance == BigDecimal.new('16.00')
  end

  Then 'the teacher account should be deducted' do
    @teacher.main_account(@school).balance == BigDecimal.new('9984.00')
    @teacher.unredeemed_account(@school).balance == BigDecimal.new('16.00')
  end
end
