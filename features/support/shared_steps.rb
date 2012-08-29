module SharedSteps
  include Spinach::DSL
 
  Given 'I am logged in as an admin' do
    visit 'http://1.lvh.me/'
    fill_in 'user_email', :with => 'school_admin1_mc_testerson@example.com'
    fill_in 'user_password', :with => 'test123'
    click_button 'Sign in'
  end

  Given 'I am logged in as a teacher' do
    visit 'http://1.lvh.me/' 
    fill_in 'user_email', :with => 'teacher1_mc_testerson@example.com'
    fill_in 'user_password', :with => 'test123'
    click_button 'Sign in'
  end

  Given 'the main account exists' do
    Plutus::Liability.create(name: CreditManager.new.main_account_name)
  end

  Given 'accounts exist' do
    100.times do
      Code.create
    end
    @school = FactoryGirl.create(:school)
    @student1 = FactoryGirl.create(:student)
    @link1 = FactoryGirl.create(:person_school_link, school: @school, person: @student1)
    @student2 = FactoryGirl.create(:student)
    @link2 = FactoryGirl.create(:person_school_link, school: @school, person: @student2)
    @school_admin = FactoryGirl.create(:school_admin)
    @admin_link = FactoryGirl.create(:person_school_link, school: @school, person: @school_admin)
    @teacher = FactoryGirl.create(:teacher)
    @teacher_link = FactoryGirl.create(:person_school_link, school: @school, person: @teacher)
    [@student1, @student2, @school_admin, @teacher].map{|x| x.activate}
  end

  When 'accounts have bucks' do
    cm = CreditManager.new
    @teacher_credits = 1000
    @school_credits = 10_000
    cm.issue_credits_to_school(@school, @school_credits)
    cm.issue_credits_to_teacher(@school, @teacher, @teacher_credits)
    cm.issue_credits_to_teacher(@school, @school_admin, @teacher_credits)
  end

   Given 'I am on the bank page' do
     visit 'http://1.lvh.me/bank'
   end

   Then 'show me the page' do
     save_and_open_page
   end
 
  Given 'I distribute printed bucks' do
    fill_in 'point1', :with => '1'
    fill_in 'point5', :with => '1'
    fill_in 'point10', :with => '1'
    click_button 'Print Bucks'
  end

  Given 'I distribute ebucks' do
    select 'Student 1 McTesterson', :from => 'student_id'
    fill_in 'points', :with => '1'
    click_button 'Create eBucks'
  end


end
