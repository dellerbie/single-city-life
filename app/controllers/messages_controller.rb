class MessagesController < ApplicationController
  before_filter :login_required
  
  def inbox
    @messages = current_user.received_messages :order => 'created_at DESC'
  end
  
  def outbox  
    @messages = current_user.sent_messages
  end
  
  def show
    @message = current_user.received_messages.find_by_id params[:id]
    @from_inbox = true
    unless @message
      @message = current_user.sent_messages.find_by_id params[:id]
      @from_inbox = false
    end
    @message.update_attribute(:read, true) if @message
  end
  
  def create
    message = Message.new(
      :sender => current_user,
      :receiver => User.find_by_login(params[:receiver_id]),
      :subject => params[:subject],
      :message => params[:message],
      :read => false
    )
    
    if message.save
      render :json => { :success => true }
    else 
      render :json => {
        :success => false,
        :msg => message.errors.full_messages,
        :errors => message.errors.full_messages
      }
    end    
  end
  
  def reply 
    parent = Message.find_by_id params[:parent_id]
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
    @message = current_user.messages.find(params[:id])
    if @message
      @message.destroy
      render :json => {
        :success => true
      }
    else 
      render :json => {
        :success => false,
        :msg => "Could not find the message you are trying to delete."
      }
    end
  end
end