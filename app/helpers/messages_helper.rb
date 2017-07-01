module MessagesHelper
  def inbox_label_with_message_count string, messages
    output = string
    count = messages.from_games.unread.count + messages.from_teacher.unread.count + messages.from_auctions.unread.count
    if count > 0
      output += " [#{count}]"
    end
    output
  end

  def teacher_inbox_label_with_message_count string, messages
    output = string
    count = messages.from_teacher.unread.count + messages.from_auctions.unread.count
    if count > 0
      output += " [#{count}]"
    end
    output
  end


  def inbox_link_for(string, messages, path, klass)
    klass += ' active' if current_page?(path)
    link_to inbox_label_with_message_count(string, messages), path, :class => klass
  end

  def inbox_count(count)
    if count > 0
      "inbox_with_count"
    else
      "inbox"
    end    
  end
end
