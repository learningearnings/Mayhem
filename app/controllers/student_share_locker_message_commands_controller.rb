class StudentShareLockerMessageCommandsController < LoggedInController
  def create
    command = StudentShareLockerMessageCommand.new(params[:student_share_locker_message_command])
    command.from_id = current_person.id
    # Rails sends us a "" to_id, and it also sends us everything as strings, so
    # let's coerce this data
    command.to_ids.delete("")
    command.to_ids.map!(&:to_i)
    if command.valid?
      command.execute!
      flash[:success] = "A message has been sent to your friend's LE messages. They can use this link to see your locker!"
    else
      flash[:error] = "Message not sent."
    end
    redirect_to locker_path
  end
end
