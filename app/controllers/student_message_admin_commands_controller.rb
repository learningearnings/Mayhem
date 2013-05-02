class StudentMessageAdminCommandsController < LoggedInController
  def create
    command = StudentMessageAdminCommand.new(params[:student_message_admin_command])
    command.from_id = current_person.id
    command.to_id = LeAdmin.first.id
    if command.valid?
      command.execute!
      flash[:success] = "Message sent successfully."
    else
      flash[:error] = "Message not sent."
    end
    redirect_to inbox_path
  end
end
