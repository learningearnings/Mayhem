class AdminMailer < ActionMailer::Base
  default from: "admin@learningearnings.com"

  def user_activity_report filename, email
    attachments[filename] = File.read("/tmp/" + filename)
    mail :to => [email,'aktaylor@sti-k12.com'], :subject => "User Activity Report", :body => "User Activity Report"
  end
  
  def tour_access_report filename, email
    attachments[filename] = File.read("/tmp/" + filename)
    mail :to => [email,'aktaylor@sti-k12.com'], :subject => "Tour Access Report", :body => "Tour Access Report"
  end
  
  def teacher_activity_report filename, email
    attachments[filename] = File.read("/tmp/" + filename)
    mail :to => [email,'aktaylor@sti-k12.com'], :subject => "Teacher Activity Report", :body => "Teacher Activity Report"
  end

  def alsde_study_report staff_filename, student_filename, email
    attachments[staff_filename] = File.read("/tmp/" + staff_filename)
    attachments[student_filename] = File.read("/tmp/" + student_filename)
    mail to: [email,'aktaylor@sti-k12.com'], subject: "ALSDE Study Report", body: "ALSDE Study Report"
  end
  
  def sign_ups_report filename, email
    attachments[filename] = File.read("/tmp/" + filename)
    mail :to => [email,'aktaylor@sti-k12.com'], :subject => "Sign Ups Report", :body => "Sign Ups Report"
  end
  
end
