class AccountController < ApplicationController
   
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
end
