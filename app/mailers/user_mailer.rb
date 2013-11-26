class UserMailer < ActionMailer::Base
  default from: "admin@learningearnings.com"

  def teacher_admin_email(message)
    @message = message
    @teacher = Person.find @message.to_id
    mail(:to => 'theteam@learningearnings.com', :subject => "#{@message.subject}")
  end

  def teacher_request_email(teacher)
    @teacher = teacher
    @url  = "http://learningearnings.com/login"
    mail(:to => 'theteam@learningearnings.com', :subject => "Teacher registration approval.")
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
