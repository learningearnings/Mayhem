class AdminMailer < ActionMailer::Base
  include ApplicationHelper
  default from: "admin@learningearnings.com"
  add_template_helper(ApplicationHelper)

  def user_activity_report filename
    attachments[filename] = File.read("/tmp/" + filename)
    mail :to => email_to, :subject => "User Activity Report", :body => "User Activity Report"
  end
  
  def tour_access_report filename
    attachments[filename] = File.read("/tmp/" + filename)
    mail :to => email_to, :subject => "Tour Access Report", :body => "Tour Access Report"
  end
  
  def teacher_activity_report filename
    attachments[filename] = File.read("/tmp/" + filename)
    mail :to => email_to, :subject => "Teacher Activity Report", :body => "Teacher Activity Report"
  end

  def alsde_study_report staff_filename, student_filename
    attachments[staff_filename] = File.read("/tmp/" + staff_filename)
    attachments[student_filename] = File.read("/tmp/" + student_filename)
    mail to: email_to, subject: "ALSDE Study Report", body: "ALSDE Study Report"
  end
  
  def sign_ups_report filename
    attachments[filename] = File.read("/tmp/" + filename)
    mail :to => email_to, :subject => "Sign Ups Report", :body => "Sign Ups Report"
  end
  
  def email_to
    if logged_in_user_email
      return [ logged_in_user_email ]
    else
      return ["aktaylor@chalkable.com","jbenson@chalkable.com"]
    end
  end
end
