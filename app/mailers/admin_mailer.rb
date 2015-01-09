class AdminMailer < ActionMailer::Base
  default from: "admin@learningearnings.com"

  def user_activity_report filename
    attachments[filename] = File.read("/tmp/" + filename)
    mail :to => ["jimmy@learningearnings.com"], :subject => "User Activity Report", :body => "User Activity Report"
  end

  def teacher_activity_report filename
    attachments[filename] = File.read("/tmp/" + filename)
    mail :to => ["jimmy@learningearnings.com", "jwood@sti-k12.com"], :subject => "Teacher Activity Report", :body => "Teacher Activity Report"
  end

  def alsde_study_report staff_filename, student_filename
    attachments[staff_filename] = File.read("/tmp/" + staff_filename)
    attachments[student_filename] = File.read("/tmp/" + student_filename)
    mail to: ["jimmy@learningearnings.com"], subject: "ALSDE Study Report", body: "ALSDE Study Report"
  end

  def buck_distributor_notification
    mail(
      to: ["jimmy@learningearnigns.com"],
      subject: "Buck Distributor",
      body: "Buck Distributor has been run"
    )
  end
end
