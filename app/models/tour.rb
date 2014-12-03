class Tour
  attr_accessor :id, :role, :integrated, :text
  @@tour_texts = []
  

  def initialize( params )
    @id = params[:id]
    @role = params[:role]
    @integrated = params[:integrated]
    @text = params[:text]  
  end

  def self.text(id, person)
    text = @@tour_texts.detect { | tour | tour.id == id && tour.role == person.type  && (tour.integrated == nil || tour.integrated == person.try(:school).try(:synced?)) }.try(:text) 
    if text == nil
      text = "No intro text found for id: #{id} and role: #{person.type} and integrated: #{person.try(:school).try(:synced?)}"
    end
    text
  end
  
  def self.all_text(person)
    #@@tour_texts.select { | tour | tour.role == person.type && tour.status = person.school.syncd? } 
  end
  
  #Student
  @@tour_texts << Tour.new({:id => "MenuBank",:role => "Student", :text => 'Bank page is where you deposit your hard earned credits.'})
  @@tour_texts << Tour.new({:id => "DepositPrintedCodes",:role => "Student", :text => 'If you received a printed code. Press the Deposit Printed Codes button to deposit the credits into your account.'})
  @@tour_texts << Tour.new({:id => "ViewCheckingHistory",:role => "Student", :text => 'You may view your checking account history by viewing the checking account history.'})
  @@tour_texts << Tour.new({:id => "MenuInbox",:role => "Student", :text => 'If your teacher sends you an electronic credit, you will receive a message below. You can deposit electronic credits by clicking on the Claim Credits link in the message.'})
  @@tour_texts << Tour.new({:id => "MenuShop",:role => "Student", :text => 'The shopping page displays all of the rewards your teacher(s) are offering. Click on a reward to make a purchase.'})
  
  #Admin Teacher Non-Integrated
  @@tour_texts << Tour.new({:id => "MenuBank",:role => "SchoolAdmin", :integrated => false, :text => 'The bank page is where you print LE credits and issue electronic LE credits.'})
  @@tour_texts << Tour.new({:id => "MenuStudents",:role => "SchoolAdmin", :integrated => false, :text => 'The students page is where you manage your students.'})
  @@tour_texts << Tour.new({:id => "AddingStudents",:role => "SchoolAdmin", :integrated => false, :text => 'Click the new students button to add students. Or upload a file below to import students.'})
  @@tour_texts << Tour.new({:id => "AddingTeachers",:role => "SchoolAdmin", :integrated => false, :text => 'You may add teachers by clicking the new teachers button.'})
  @@tour_texts << Tour.new({:id => "MenuClassrooms",:role => "SchoolAdmin", :integrated => false, :text => 'The classrooms page allows you to create groups of students. Simply enter a name for the classroom, click create, then click the classroom name.'})
  @@tour_texts << Tour.new({:id => "MenuPlay",:role => "SchoolAdmin", :integrated => false, :text => 'This page allows you to create auctions for your school.'})
  @@tour_texts << Tour.new({:id => "MenuShop",:role => "SchoolAdmin", :integrated => false, :text => 'This page allows you to create rewards for your students.'})
  @@tour_texts << Tour.new({:id => "AddOrManageYourRewards",:role => "SchoolAdmin", :integrated => false, :text => 'This button allows you to add or manage a reward.'})
  @@tour_texts << Tour.new({:id => "CreateNewCustomReward",:role => "SchoolAdmin", :integrated => false, :text => 'Click this button to add a reward to your classroom. You may also customize an existing reward template by clicking on it below.'})
  @@tour_texts << Tour.new({:id => "MenuReports",:role => "SchoolAdmin", :integrated => false, :text => 'You may run a purchase report or earnings report for your students.'})
  
  #SchoolAdmin Teacher Integrated
  @@tour_texts << Tour.new({:id => "MenuBank",:role => "SchoolAdmin", :integrated => true, :text => 'The bank page is where you print LE credits and issue electronic LE credits.'})
  @@tour_texts << Tour.new({:id => "AutoCredits",:role => "SchoolAdmin", :integrated => true, :text => 'This tab allows you to set parameters for iNow to automatically send electronic credits to your students.'})
  @@tour_texts << Tour.new({:id => "MenuStudents",:role => "SchoolAdmin", :integrated => true, :text => 'The students page is where you manage your students. Or upload a file below to import students.'})
  @@tour_texts << Tour.new({:id => "AddingStudents",:role => "SchoolAdmin", :integrated => true, :text => 'Click the new students button to add students. Or upload a file below to import students.'})
  @@tour_texts << Tour.new({:id => "AddingTeachers",:role => "SchoolAdmin", :integrated => true, :text => 'You may add teachers by clicking the new teachers button.'})
  @@tour_texts << Tour.new({:id => "MenuClassrooms",:role => "SchoolAdmin", :integrated => true, :text => 'The classrooms page allows you to create groups of students. Simply enter a name for the classroom, click create, then click the classroom name.'})
  @@tour_texts << Tour.new({:id => "MenuPlay",:role => "SchoolAdmin", :integrated => true, :text => 'This page allows you to create auctions for your school.'})
  @@tour_texts << Tour.new({:id => "MenuShop",:role => "SchoolAdmin", :integrated => true, :text => 'This page allows you to create rewards for your students.'})
  @@tour_texts << Tour.new({:id => "AddOrManageYourRewards",:role => "SchoolAdmin", :integrated => true, :text => 'This button allows you to add or manage a reward.'})
  @@tour_texts << Tour.new({:id => "CreateNewCustomReward",:role => "SchoolAdmin", :integrated => true, :text => 'Click this button to add a reward to your classroom. You may also customize an existing reward template by clicking on it below.'})
  @@tour_texts << Tour.new({:id => "MenuReports",:role => "SchoolAdmin", :integrated => true, :text => 'You may run a purchase report or earnings report for your students.'})

  #Teacher Non-Integrated
  @@tour_texts << Tour.new({:id => "MenuBank",:role => "Teacher", :integrated => false, :text => 'The bank page is where you print LE credits and issue electronic LE credits.'})
  @@tour_texts << Tour.new({:id => "MenuStudents",:role => "Teacher", :integrated => false, :text => 'The students page is where you manage your students. Or upload a file below to import students.'})
  @@tour_texts << Tour.new({:id => "AddingStudents",:role => "Teacher", :integrated => false, :text => 'Click the new students button to add students. Or upload a file below to import students.'})
  @@tour_texts << Tour.new({:id => "AddingTeachers",:role => "Teacher", :integrated => false, :text => 'You may add teachers by clicking the new teachers button.'})
  @@tour_texts << Tour.new({:id => "MenuClassrooms",:role => "Teacher", :integrated => false, :text => 'The classrooms page allows you to create groups of students. Simply enter a name for the classroom, click create, then click the classroom name.'})
  @@tour_texts << Tour.new({:id => "MenuPlay",:role => "Teacher", :integrated => false, :text => 'This page allows you to create auctions for your school.'})
  @@tour_texts << Tour.new({:id => "MenuShop",:role => "Teacher", :integrated => false, :text => 'This page allows you to create rewards for your students.'})
  @@tour_texts << Tour.new({:id => "AddOrManageYourRewards",:role => "Teacher", :integrated => false, :text => 'This button allows you to add or manage a reward.'})
  @@tour_texts << Tour.new({:id => "CreateNewCustomReward",:role => "Teacher", :integrated => false, :text => 'Click this button to add a reward to your classroom. You may also customize an existing reward template by clicking on it below.'})
  @@tour_texts << Tour.new({:id => "MenuReports",:role => "Teacher", :integrated => false, :text => 'You may run a purchase report or earnings report for your students.'})

  #Teacher Integrated
  @@tour_texts << Tour.new({:id => "MenuBank",:role => "Teacher", :integrated => true, :text => 'The bank page is where you print LE credits and issue electronic LE credits.'})
  @@tour_texts << Tour.new({:id => "MenuStudents",:role => "Teacher", :integrated => true, :text => 'The students page is where you manage your students. Or upload a file below to import students.'})
  @@tour_texts << Tour.new({:id => "AddingStudents",:role => "Teacher", :integrated => true, :text => 'Click the new students button to add students. Or upload a file below to import students.'})
  @@tour_texts << Tour.new({:id => "AddingTeachers",:role => "Teacher", :integrated => true, :text => 'You may add teachers by clicking the new teachers button.'})
  @@tour_texts << Tour.new({:id => "MenuClassrooms",:role => "Teacher", :integrated => true, :text => 'The classrooms page allows you to create groups of students. Simply enter a name for the classroom, click create, then click the classroom name.'})
  @@tour_texts << Tour.new({:id => "MenuPlay",:role => "Teacher", :integrated => true, :text => 'This page allows you to create auctions for your school.'})
  @@tour_texts << Tour.new({:id => "MenuShop",:role => "Teacher", :integrated => true, :text => 'This page allows you to create rewards for your students.'})
  @@tour_texts << Tour.new({:id => "AddOrManageYourRewards",:role => "Teacher", :integrated => true, :text => 'This button allows you to add or manage a reward.'})
  @@tour_texts << Tour.new({:id => "CreateNewCustomReward",:role => "Teacher", :integrated => true, :text => 'Click this button to add a reward to your classroom. You may also customize an existing reward template by clicking on it below.'})
  @@tour_texts << Tour.new({:id => "MenuReports",:role => "Teacher", :integrated => true, :text => 'You may run a purchase report or earnings report for your students.'})


  
end