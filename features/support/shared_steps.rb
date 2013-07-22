module SharedSteps
  include Spinach::DSL

  Given 'the default filter exists' do
    filter = Filter.create
    Filter.stubs(:find).with(1).returns filter
  end

  Given 'I am logged in as an admin' do
    visit 'http://1.lvh.me/'
    fill_in 'user_username', :with => @school_admin.user.username
    fill_in 'user_password', :with => '123456'
    page.find(".login-button").click
  end

  Given 'I am logged in as a teacher' do
    visit 'http://1.lvh.me/'
    fill_in 'user_username', :with => @teacher.user.username
    fill_in 'user_password', :with => '123456'
    page.find(".login-button").click
  end

  Given 'I am logged in as a student' do
    visit 'http://1.lvh.me/'
    fill_in 'user_username', :with => @student1.user.username
    fill_in 'user_password', :with => '123456'
    page.find(".login-button").click
  end

  Given 'the main LE account exists' do
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
    @teacher = FactoryGirl.create(:teacher, first_name: "Teacher", last_name: "Test")
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

   Given 'I am on the schools settings page' do
     visit 'http://1.lvh.me/schools/settings'
   end

   Given 'I am on the teachers bank page' do
     visit 'http://1.lvh.me/teachers/bank'
   end

   Given 'I am on the school admins bank page' do
     visit 'http://1.lvh.me/school_admins/bank'
   end

   Given 'I am on the messages page' do
     visit 'http://1.lvh.me/inbox'
   end

   Given 'I am on the teacher messages page' do
     visit 'http://1.lvh.me/inbox/teacher_messages'
   end

   Then 'show me the page' do
     save_and_open_page
   end

  Given 'I distribute printed bucks' do
    fill_in 'point1', :with => '1'
    fill_in 'point5', :with => '1'
    fill_in 'point10', :with => '1'
    click_button 'Print These Credits'
  end

  Given 'I distribute ebucks' do
    select @student1.name, :from => 'student_id'
    fill_in 'points', :with => '16'
    click_button 'Send These Credits'
  end
end
