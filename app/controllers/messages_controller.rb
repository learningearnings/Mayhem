class MessagesController < LoggedInController
  layout :layout

  def index
    friend_messages
    render 'friend_messages'
  end

  def friend_messages
    @received_messages = current_person.received_messages
    @messages = @received_messages.not_hidden.from_friend.page params[:page]
  end

  def school_messages
    @received_messages = current_person.received_messages
    @messages = @received_messages.not_hidden.from_school.page params[:page]
  end

  def teacher_messages
    @received_messages = current_person.received_messages
    @messages = @received_messages.not_hidden.from_teacher.page params[:page]
  end

  def system_messages
    @received_messages = current_person.received_messages
    @messages = @received_messages.not_hidden.from_system.page params[:page]
  end

  def reply
    @old_message = Message.find(params[:message_id])
    @message = StudentMessageStudentCommand.new
    @message.to_ids = []
    @message.to_ids << @old_message.from_id
    @message_images = MessageImage.page params[:page]
  end

  def admin_message
    @message = StudentMessageAdminCommand.new
  end

  def show
    @message = current_person.received_messages.find(params[:id])
    @message.read!
  end

  def new
    @message = StudentMessageStudentCommand.new
    @grademates = current_person.grademates
    @message_images = MessageImage.page params[:page]
  end

  def get_image_results
    @message_images = MessageImage.page params[:page]
    render partial: '/messages/images'
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
