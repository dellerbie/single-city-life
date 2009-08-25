class Message < ActiveRecord::Base
  belongs_to :sender, :class_name => "User", :foreign_key => :sender_id
  belongs_to :receiver, :class_name => "User", :foreign_key => :receiver_id
  
  acts_as_tree :order => "created_at ASC"
  
  validates_presence_of   :sender
  validates_presence_of   :receiver
  validates_length_of     :subject, :maximum => 50, :allow_blank => false
  validates_presence_of   :message
  
  def self.per_page
    10
  end
  
  def root
    root = self.parent == nil ? self : self.parent.root
  end
  
  # returns an array of messages that represent the entire conversational thread
  # that this message is in
  def thread
    msgs = []
    if self.parent
      append_message_and_children self.parent, msgs
    else 
      append_message_and_children self, msgs
    end
  end
  
  private 
  
  def append_message_and_children(msg, msgs)
    msgs << msg
    msg.children.each do |m|
      msgs << m
    end
    msgs
  end
end