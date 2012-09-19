class MessagesController < LoggedInController
  layout :layout

  def index
    friend_messages
    render 'friend_messages'
  end

  def friend_messages
    @received_messages = current_person.received_messages
    @messages = @received_messages.from_friend.page params[:page]

  end

  def school_messages
    @received_messages = current_person.received_messages
    @messages = @received_messages.from_school.page params[:page]

  end

  def teacher_messages
    @received_messages = current_person.received_messages
    @messages = @received_messages.from_teacher.page params[:page]

  end

  def system_messages
    @received_messages = current_person.received_messages
    @messages = @received_messages.from_system.page params[:page]

  end

  def reply
    @old_message = Message.find(params[:message_id])
    @message = StudentMessageStudentCommand.new
    @message.to_ids = []
    @message.to_ids << @old_message.from_id
    @message_images = MessageImage.first(10)
  end

  def show
    @message = current_person.received_messages.find(params[:id])
    @message.read!
  end

  def new
    @message = StudentMessageStudentCommand.new
    @grademates = current_person.grademates
    @message_images = MessageImage.first(10)
  end

  protected
  # No layout if this is an xhr request
  def layout
    if request.xhr?
      return false
    else
      return 'application'
    end
  end
end
