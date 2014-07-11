class AdminMailer < ActionMailer::Base
  default from: "admin@learningearnings.com"

  def user_activity_report filename
    attachments[filename] = File.read("/tmp/" + filename)
    mail :to => "jimmy@learningearnings.com", :subject => "User Activity Report", :body => "User Activity Report"
  end
end
