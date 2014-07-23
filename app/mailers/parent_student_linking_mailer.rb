class ParentStudentLinkingMailer < ActionMailer::Base
  default from: "admin@learningearnings.com"

  def link_with_your_child_email(parent_email, parent_student_link)
    @parent_student_link = parent_student_link
    mail(to: parent_email, subject: "Link with your child!")
  end
end
