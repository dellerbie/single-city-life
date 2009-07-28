module MessagesHelper
  
  def num_unread_messages
    current_user.num_unread_messages == 0 ? "" : "(#{current_user.num_unread_messages})"
  end
  
end
