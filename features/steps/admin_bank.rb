class AdminBank < Spinach::FeatureSteps
  include SharedSteps
  Given 'I am logged in as an admin' do
    visit 'http://1.lvh.me/'
    fill_in 'user_email', :with => 'school_admin1_mc_testerson@example.com'
    fill_in 'user_password', :with => 'test123'
    click_button 'Sign in'
  end

  Given 'I distribute bucks for a teacher' do
    select 'Teacher 1 McTesterson', :from => 'teacher_id'
    fill_in 'point1', :with => '1'
    fill_in 'point5', :with => '1'
    fill_in 'point10', :with => '1'
    click_button 'Create Bucks'
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
