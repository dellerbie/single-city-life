class AccountController < ApplicationController
  before_filter :login_required 
   
  def index
  end
  
  def edit
  end
  
  def update_password
    @user = current_user
    @user.change_password(params)
    if @user.save
      flash[:notice] = "Password successfully updated."
      redirect_to :action => :edit
    else 
      render :action => :edit
    end
  end
  
  def update_email
    @user = current_user
    @user.change_email(params)
    if @user.save
      flash[:notice] = "Email successfully updated."
      redirect_to :action => :edit
    else 
      render :action => :edit
    end
  end
  
  def enable
    @user = current_user
    if @user.update_attribute(:enabled, params)
      flash[:notice] = "Your account has been disabled and will not be visible to the community.  You can enable your account at any time."
    else
      flash[:error] = "There was a problem disabling this user."
    end
    redirect_to :action => :edit
  end
  
end
