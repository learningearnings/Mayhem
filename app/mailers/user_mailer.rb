class UserMailer < ActionMailer::Base
  default from: "noreply@learningearnings.com"

  def teacher_admin_email(message, school, alternate_email=nil)
    @message = message
    @school = school
    @alternate_email = alternate_email
    @teacher = Person.find @message.from_id
    if @school.sti_id.present?
      mail(to: 'stisupport@learningearnings.com', :subject => "#{@message.subject}")
    else
      mail(:to => 'theteam@learningearnings.com', :subject => "#{@message.subject}")
    end
  end

  def teacher_self_signup_email(teacher)
    @teacher = teacher
    mail(to: @teacher.user.email, subject: 'Thank you for registering with Learning Earnings.')
  end

  def teacher_request_email(teacher)
    @teacher = teacher
    @url  = "http://learningearnings.com/login"
    mail(:to => 'theteam@learningearnings.com', :subject => "JOIN REQUEST.")
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

  def bulk_update_notifier(email)
    mail(:to => email, :subject => "Batch update complete.")
  end

end
