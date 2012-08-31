class StudentBank < Spinach::FeatureSteps
  include SharedSteps
  include ActionView::Helpers::UrlHelper


  Then 'the teacher unredeemed account should be deducted' do
    @teacher.main_account(@school).balance == BigDecimal.new('9984.00')
    @teacher.unredeemed_account(@school).balance == BigDecimal.new('16.00')
  end

  Then 'the student account should recieve bucks' do 
    @student1.checking_account.balance == BigDecimal.new('5.00')
  end

 Then 'I enter the code' do
   fill_in 'code', :with => @otu_code.code
   click_button 'Redeem'
 end

 Given 'a valid code exists' do
   @otu_code = OtuCode.create(:person_school_link_id => @teacher.id, :points => BigDecimal('5'), :expires_at => (Time.now + 45.days))
   @otu_code.generate_code('AL')
   cm = CreditManager.new
   cm.purchase_printed_bucks(@school, @teacher, @otu_code.points)
 end

 Given 'a valid ecode exists' do
   @otu_code = OtuCode.create(:person_school_link_id => @teacher.id, :points => BigDecimal('5'), :expires_at => (Time.now + 45.days), :ebuck => true)
   @otu_code.generate_code('AL')
   cm = CreditManager.new
   cm.purchase_ebucks(@school, @teacher, @student1, @otu_code.points)
   message = Message.create(:from_id => @teacher.id, 
                            :to_id => @student1.id, 
                            :subject => 'You\'ve been awarded LE Bucks',
                            :body => "Click here to claim your award:
                            #{link_to 'Claim Bucks', ("/redeem_bucks?student_id=#{@student1.id}&code=#{@otu_code.code}")}")
 end

 Given 'I click on a buck message' do
   click_link 'Read Message'
   click_link 'Claim Bucks'
 end
end
