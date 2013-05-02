class UserMailer < ActionMailer::Base
  default from: "admin@learningearnings.com"

  def teacher_request_email(teacher)
    @teacher = teacher
    @url  = "http://learningearnings.com/login"
    mail(:to => 'rclements@gmail.com', :subject => "Teacher registration approval.")
  end

  def teacher_approval_email(teacher)
    @teacher = teacher
    @url  = "http://learningearnings.com/login"
    mail(:to => teacher.email, :subject => "Teacher registration approval.")
  end

  def teacher_deny_email(teacher)
    @teacher = teacher
    @url  = "http://learningearnings.com/login"
    mail(:to => teacher.email, :subject => "Teacher registration denied.")
  end

end
