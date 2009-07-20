class Message < ActiveRecord::Base
  belongs_to :sender, :class_name => "User", :foreign_key => :sender_id
  belongs_to :receiver, :class_name => "User", :foreign_key => :receiver_id
  
  acts_as_tree :order => "created_at ASC"
  
  validates_presence_of   :sender
  validates_presence_of   :receiver
  validates_length_of     :subject, :maximum => 50, :allow_blank => false
  validates_length_of     :message, :minimum => 1
  
  def root
    root = self.parent == nil ? self : self.parent.root
  end
end