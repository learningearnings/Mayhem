class StudentMessageAdminCommandsController < LoggedInController
  def create
    command = StudentMessageAdminCommand.new(params[:student_message_admin_command])
    command.from_id = current_person.id
    command.to_id = LeAdmin.first.id
    if command.valid?
      command.execute!
      flash[:success] = "Message sent successfully."
      handle_redirect(params[:refurl])
    else
      flash[:error] = "Message not sent.  " + command.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def handle_redirect(refurl)
    redirect_to refurl || inbox_path
  end
end
