class MessagesController < LoggedInController
  def index
    @received_messages = current_person.received_messages
  end

  def show
    @message = current_person.received_messages.find(params[:id])
    if request.xhr?
      render layout: false
    else
      render
    end
  end
end
