class TeacherBank < Spinach::FeatureSteps
  include SharedSteps
 
  Given 'I am logged in as a teacher' do
    visit 'http://1.lvh.me/' 
    fill_in 'user_email', :with => 'teacher1_mc_testerson@example.com'
    fill_in 'user_password', :with => 'test123'
    click_button 'Sign in'
  end

  Then 'the teacher account should be deducted' do
    @teacher.main_account(@school).balance == BigDecimal.new('9984.00')
    @teacher.unredeemed_account(@school).balance == BigDecimal.new('16.00')
  end

end

 
