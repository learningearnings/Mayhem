module Teachers
  class MessagesController < Teachers::BaseController
    layout :layout
    before_filter :get_received_messages

    def index
      redirect_to teachers_peer_messages_path
    end
    
    def admin_messages
      @messages = @received_messages.for_admin.page params[:page]
      @messages.map{|x| x.read!}      
    end

    def peer_messages
      @messages = @received_messages.from_teacher.page params[:page]
      @messages.map{|x| x.read!}
    end

    def auctions_messages
      @messages = @received_messages.from_auctions.page params[:page]
      @messages.map{|x| x.read!}
    end

    def games_messages
      @messages = @received_messages.from_games.page params[:page]
      @messages.map{|x| x.read!}
    end

    def system_messages
      @messages = @received_messages.from_system.page params[:page]
      @messages.map{|x| x.read!}
    end

    def peer_message
      peers = current_person.peers_at(current_school)
      message = TeacherMessagePeerCommand.new
      render locals: { peers: peers, message: message }
    end

    def admin_message
      @message = TeacherMessageAdminCommand.new
      @message.subject = params[:subject]
    end

    def classroom_message
      message = TeacherMessageClassroomCommand.new
      classrooms = current_person.classrooms_for_school(current_school)
      render locals: { message: message, classrooms: classrooms }
    end

    def show
      @message = current_person.received_messages.find(params[:id])
      @message.read!
    end

    def reply
      old_message = Message.find(params[:message_id])
      message = TeacherMessagePeerCommand.new
      peers = current_person.peers_at(current_school)
      render locals: { peers: peers, message: message, old_message: old_message }
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
