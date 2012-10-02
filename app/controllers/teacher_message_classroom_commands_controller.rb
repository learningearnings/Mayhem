class TeacherMessageClassroomCommandsController < Teachers::BaseController
  def create
    command = TeacherMessageClassroomCommand.new(params[:teacher_message_classroom_command])
    command.from_id = current_person.id
    if command.valid?
      command.execute!
      flash[:success] = "Message sent successfully."
    else
      flash[:error] = "Message not sent."
    end
    redirect_to teachers_inbox_path
  end
end
