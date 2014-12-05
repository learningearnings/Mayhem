class Tour
 
  def self.text(id, person)
    if person.is_a?(Student)
      text = @@tour_texts[id + ":Student"]
    elsif person.is_a?(SchoolAdmin)
      text = (person.try(:school).try(:synced?)) ? (@@tour_texts[id + ":SchoolAdmin:I"]) : (@@tour_texts[id + ":SchoolAdmin:NI"])
    elsif person.is_a?(Teacher)
      text = (person.try(:school).try(:synced?)) ? (@@tour_texts[id + ":Teacher:I"]) : (@@tour_texts[id + ":Teacher:NI"])
    else
      text = nil
    end
    if text == nil
      text = "No intro text found for id: #{id} and role: #{person.type} and integrated: #{person.try(:school).try(:synced?)}"
    end
    text
  end
  
  @@tour_texts = {
    
      #Student
      'MenuBank:Student' => 'Bank page is where you deposit your hard earned credits.',
      'DepositPrintedCodes:Student' => 'If you received a printed code. Press the Deposit Printed Codes button to deposit the credits into your account.',
      'ViewCheckingHistory:Student' => 'You may view your checking account history by viewing the checking account history.',
      'MenuInbox:Student' => 'If your teacher sends you an electronic credit, you will receive a message below. You can deposit electronic credits by clicking on the Claim Credits link in the message.',
      'MenuShop:Student' => 'The shopping page displays all of the rewards your teacher(s) are offering. Click on a reward to make a purchase.',      
 
       #SchoolAdmin Non-Integrated
      'MenuBank:SchoolAdmin:NI' => 'The bank page is where you print LE credits and issue electronic LE credits.',
      'AutoCredits:SchoolAdmin:NI' => 'This tab allows you to set parameters for iNow to automatically send electronic credits to your students.',  
      'MenuStudents:SchoolAdmin:NI' => 'The students page is where you manage your students.',
      'AddingStudents:SchoolAdmin:NI' => 'Click the new students button to add students. Or upload a file below to import students.',
      'AddingTeachers:SchoolAdmin:NI' => 'You may add teachers by clicking the new teachers button.',
      'MenuClassrooms:SchoolAdmin:NI' => 'The classrooms page allows you to create groups of students. Simply enter a name for the classroom, click create, then click the classroom name.',
      'MenuPlay:SchoolAdmin:NI' => 'This page allows you to create auctions for your school.',
      'MenuShop:SchoolAdmin:NI' => 'This page allows you to create rewards for your students.',
      'AddOrManageYourRewards:SchoolAdmin:NI' => 'This button allows you to add or manage a reward.',
      'CreateNewCustomReward:SchoolAdmin:NI' => 'Click this button to add a reward to your classroom. You may also customize an existing reward template by clicking on it below.',
      'MenuReports:SchoolAdmin:NI' => 'You may run a purchase report or earnings report for your students.',
      
      #SchoolAdmin Teacher Integrated
      'MenuBank:SchoolAdmin:I' => 'The bank page is where you print LE credits and issue electronic LE credits.',
      'AutoCredits:SchoolAdmin:I' => 'This tab allows you to set parameters for iNow to automatically send electronic credits to your students.',
      'MenuStudents:SchoolAdmin:I' => 'The students page is where you manage your students. Or upload a file below to import students.',
      'AddingStudents:SchoolAdmin:I' => 'Click the new students button to add students. Or upload a file below to import students.',
      'AddingTeachers:SchoolAdmin:I' => 'You may add teachers by clicking the new teachers button.',
      'MenuClassrooms:SchoolAdmin:I' => 'The classrooms page allows you to create groups of students. Simply enter a name for the classroom, click create, then click the classroom name.',
      'MenuPlay:SchoolAdmin:I' => 'This page allows you to create auctions for your school.',
      'MenuShop:SchoolAdmin:I' => 'This page allows you to create rewards for your students.',
      'AddOrManageYourRewards:SchoolAdmin:I' => 'This button allows you to add or manage a reward.',
      'CreateNewCustomReward:SchoolAdmin:I' => 'Click this button to add a reward to your classroom. You may also customize an existing reward template by clicking on it below.',
      'MenuReports:SchoolAdmin:I' => 'You may run a purchase report or earnings report for your students.',
    
      #Teacher Non-Integrated
      'MenuBank:Teacher:NI' => 'The bank page is where you print LE credits and issue electronic LE credits.',
      'MenuStudents:Teacher:NI' => 'The students page is where you manage your students. Or upload a file below to import students.',
      'AddingStudents:Teacher:NI' => 'Click the new students button to add students. Or upload a file below to import students.',
      'AddingTeachers:Teacher:NI' => 'You may add teachers by clicking the new teachers button.',
      'MenuClassrooms:Teacher:NI' => 'The classrooms page allows you to create groups of students. Simply enter a name for the classroom, click create, then click the classroom name.',
      'MenuPlay:Teacher:NI' => 'This page allows you to create auctions for your school.',
      'MenuShop:Teacher:NI' => 'This page allows you to create rewards for your students.',
      'AddOrManageYourRewards:Teacher:NI' => 'This button allows you to add or manage a reward.',
      'CreateNewCustomReward:Teacher:NI' => 'Click this button to add a reward to your classroom. You may also customize an existing reward template by clicking on it below.',
      'MenuReports:Teacher:NI' => 'You may run a purchase report or earnings report for your students.',
    
      #Teacher Integrated
      'MenuBank:Teacher:I' => 'The bank page is where you print LE credits and issue electronic LE credits.',
      'MenuStudents:Teacher:I' => 'The students page is where you manage your students. Or upload a file below to import students.',
      'AddingStudents:Teacher:I' => 'Click the new students button to add students. Or upload a file below to import students.',
      'AddingTeachers:Teacher:I' => 'You may add teachers by clicking the new teachers button.',
      'MenuClassrooms:Teacher:I' => 'The classrooms page allows you to create groups of students. Simply enter a name for the classroom, click create, then click the classroom name.',
      'MenuPlay:Teacher:I' => 'This page allows you to create auctions for your school.',
      'MenuShop:Teacher:I' => 'This page allows you to create rewards for your students.',
      'AddOrManageYourRewards:Teacher:I' => 'This button allows you to add or manage a reward.',
      'CreateNewCustomReward:Teacher:I' => 'Click this button to add a reward to your classroom. You may also customize an existing reward template by clicking on it below.',
      'MenuReports:Teacher:I' => 'You may run a purchase report or earnings report for your students.'
  
  }


  
end