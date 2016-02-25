class MessagesController < LoggedInController
  layout :layout
  before_filter :get_received_messages

  def index
    redirect_to teacher_messages_path
  end

  def friend_messages
    @messages = @received_messages.from_friend.page params[:page]
    @messages.map{|x| x.read!}
  end

  def school_messages
    @messages = @received_messages.from_school.page params[:page]
    @messages.map{|x| x.read!}
  end

  def teacher_messages
    @messages = @received_messages.from_teacher.page params[:page]
    @messages.map{|x| x.read!}
  end

  def system_messages
    @messages = @received_messages.from_system.page params[:page]
    @messages.map{|x| x.read!}
  end

  def games_messages
    @messages = @received_messages.from_games.page params[:page]
    @messages.map{|x| x.read!}
  end
  
  def auctions_messages
    @messages = @received_messages.from_auctions.page params[:page]
    @messages.map{|x| x.read!}
  end
  
  def reply
    @old_message = Message.find(params[:message_id])
    @message = StudentMessageStudentCommand.new
    @message.to_ids = []
    @message.to_ids << @old_message.from_id
    @message_images = MessageImage.page params[:page]
  end

  def admin_message
    if current_person.type == "Teacher"
      @message = TeacherMessageAdminCommand.new
    else
      @message = StudentMessageAdminCommand.new
    end
    @message.subject = params[:subject]
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

  def get_received_messages
    @received_messages = current_person.received_messages.not_hidden.order("created_at DESC")
  end
end
