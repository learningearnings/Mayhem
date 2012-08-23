class MessagesController < LoggedInController
  def index
    @received_messages = current_person.received_messages
  end
end
