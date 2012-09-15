class MessagesController < LoggedInController
  layout :layout

  def index
    @received_messages = current_person.received_messages
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
