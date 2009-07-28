class MessagesController < ApplicationController
  before_filter :login_required
  
  def inbox
    @messages = current_user.received_messages.paginate :all, :page => params[:page] || 1, :order => 'created_at DESC'
    @from_inbox = true
    render :template => "messages/mailbox"
  end
  
  def outbox  
    @messages = current_user.sent_messages.paginate :all, :page => params[:page] || 1, :order => 'created_at DESC'
    @from_inbox = false
    render :template => "messages/mailbox"
  end
  
  # going to need some pagination in here, but more tricky
  def show
    @message = current_user.received_messages.find_by_id params[:id]
    if @message
      # showing an inbox message
      @from_inbox = true
      @message.update_attribute(:read, true)
    else 
      # showing an outbox message
      @from_inbox = false
      @message = current_user.sent_messages.find_by_id params[:id]
      unless @message
        flash[:notice] = "Could not find the message you are trying to view."
        redirect_to :action => inbox
      end
    end
  end
  
  def create
    receiver = User.find_by_login(params[:receiver_id])
    json = {}
    message = Message.new(
      :sender => current_user,
      :receiver => receiver,
      :subject => params[:subject],
      :message => params[:message],
      :read => false
    )
    if receiver.nil?
      json = {
        :success => false,
        :message => "The user you are trying to send a message to does not exist.",
        :errors => "The user you are trying to send a message to does not exist."
      }
    elsif receiver.id == current_user.id
      json = {
        :success => false,
        :msg => "You can not send a message to yourself.",
        :errors => "You can not send a message to yourself."
      }
    elsif message.save
      json = { :success => true }
    else 
      json = {
        :success => false,
        :msg => message.errors.full_messages,
        :errors => message.errors.full_messages
      }
    end
    
    render :json => json
  end
  
  def reply 
    parent = Message.find :first, :conditions => ["receiver_id = :receiver_id and id = :id", {:receiver_id => current_user.id, :id => params[:parent_id]}]
    receiver = User.find_by_login params[:receiver_id]
    if parent and receiver
      new_msg = parent.children.create(
        :subject => params[:subject],
        :message => params[:message],
        :receiver => receiver,
        :sender => current_user,
        :read => false
      )
      
      if new_msg.valid?
        render :json => { 
          :id => new_msg.id,
          :success => true,
          :sender_default_photo => new_msg.sender.default_photo,
          :sender => new_msg.sender.login,
          :sent_on => new_msg.created_at.to_formatted_s(:long),
          :message => new_msg.message
        }
      else 
        render :json => {
          :success => false,
          :msg => new_msg.errors.full_messages
        }
      end
    else 
      render :json => {
        :success => false,
        :msg => "Could not find the message and/or user you are trying to reply to.  Please refresh your browser and try again."
      }
    end
  end
  
  def destroy 
    @message = current_user.received_messages.find_by_id params[:id]
    if @message
      @message.update_attribute(:receiver_deleted, true)
    else
      @message = current_user.sent_messages.find_by_id params[:id]
      @message.update_attribute(:sender_deleted, true)
    end
    
    # even if there's an error, no big deal
    render :json => { :success => true } 
  end
end