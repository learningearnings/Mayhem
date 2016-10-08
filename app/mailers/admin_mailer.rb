class AdminMailer < ActionMailer::Base
  default from: "noreply@learningearnings.com"

  def user_activity_report filename
    attachments[filename] = File.read("/tmp/" + filename)
    mail :to => ["aktaylor@chalkable.com","lrushing@chalkable.com"], :subject => "User Activity Report", :body => "User Activity Report"
  end
  
  def tour_access_report filename
    attachments[filename] = File.read("/tmp/" + filename)
    mail :to => ["aktaylor@chalkable.com","lrushing@chalkable.com"], :subject => "Tour Access Report", :body => "Tour Access Report"
  end
  
  def user_activity_summary_report filename, email_recipients
    attachments[filename] = File.read("/tmp/" + filename)
    recipients = ["aktaylor@chalkable.com"] + email_recipients.split(",") 
    mail :to => recipients, :subject => "User Activity Summary Report", :body => "User Activity Summary Report"
  end
  
  def user_activity_detail_report filename, email_recipients
    tlfn = "teacher_logins" + filename
    tcfn = "teacher_credits" + filename
    slfn = "student_logins" + filename
    scfn = "student_credits" + filename
    attachments[tlfn] = File.read("/tmp/" + tlfn)
    attachments[tcfn] = File.read("/tmp/" + tcfn)
    attachments[slfn] = File.read("/tmp/" + slfn)
    attachments[scfn] = File.read("/tmp/" + scfn)           
    recipients = ["aktaylor@chalkable.com"] + email_recipients.split(",") 
    mail :to => recipients, :subject => "User Activity Detail Reports", :body => "User Activity Detail Reports"
  end
  
  def district_dashboard_report filename, email_recipients
    district_summary = "district_summary" + filename
    #tcfn = "teacher_credits" + filename
    #slfn = "student_logins" + filename
    #scfn = "student_credits" + filename
    attachments[district_summary] = File.read("/tmp/" + district_summary)
    #attachments[tcfn] = File.read("/tmp/" + tcfn)
    #attachments[slfn] = File.read("/tmp/" + slfn)
    #attachments[scfn] = File.read("/tmp/" + scfn)           
    recipients = ["aktaylor@chalkable.com"] + email_recipients.split(",") 
    mail :to => recipients, :subject => "District Dashboard Report", :body => "District Dashboard Reports"
  end  
  
  def teacher_activity_report filename
    attachments[filename] = File.read("/tmp/" + filename)
    mail :to => ["aktaylor@chalkable.com","lrushing@chalkable.com", "jwood@sti-k12.com"], :subject => "Teacher Activity Report", :body => "Teacher Activity Report"
  end

  def alsde_study_report staff_filename, student_filename
    attachments[staff_filename] = File.read("/tmp/" + staff_filename)
    attachments[student_filename] = File.read("/tmp/" + student_filename)
    mail to: ["aktaylor@chalkable.com","lrushing@chalkable.com"], subject: "ALSDE Study Report", body: "ALSDE Study Report"
  end
  
  def sign_ups_report filename
    attachments[filename] = File.read("/tmp/" + filename)
    mail :to => ["aktaylor@chalkable.com","lrushing@chalkable.com"], :subject => "Sign Ups Report", :body => "Sign Ups Report"
  end
end
