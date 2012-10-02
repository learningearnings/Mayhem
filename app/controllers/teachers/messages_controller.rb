module Teachers
  class MessagesController < Teachers::BaseController
    layout :layout
    before_filter :get_received_messages

    def index
      redirect_to teachers_peer_messages_path
    end

    def peer_messages
      @messages = @received_messages.from_teacher.page params[:page]
      @messages.map{|x| x.read!}
    end

    def system_messages
      @messages = @received_messages.from_system.page params[:page]
      @messages.map{|x| x.read!}
    end

    def admin_message
      @message = TeacherMessageAdminCommand.new
      @message.subject = params[:subject]
    end

    def show
      @message = current_person.received_messages.find(params[:id])
      @message.read!
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
end
