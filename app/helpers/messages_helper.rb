module MessagesHelper
  public
  def inbox_label_with_message_count string, messages
    output = string
    if messages.unread.any?
      output += " [#{messages.unread.count}]"
    end
    output
  end

  def inbox_link_for(string, messages, path, klass)
    klass += ' active' if current_page?(path)
    link_to inbox_label_with_message_count(string, messages), path, :class => klass
  end
end
