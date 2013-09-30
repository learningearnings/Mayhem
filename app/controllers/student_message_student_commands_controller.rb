class StudentMessageStudentCommandsController < LoggedInController
  def create
    command = StudentMessageStudentCommand.new(params[:student_message_student_command])
    command.from_id = current_person.id
    # Rails sends us a "" to_id, and it also sends us everything as strings, so
    # let's coerce this data
    command.to_ids.delete("")
    command.to_ids.map!(&:to_i)
    if command.valid?
      command.execute!
      flash[:success] = "Message sent successfully."
    else
      flash[:error] = "Message not sent."
    end
    redirect_to inbox_path
  end
end
