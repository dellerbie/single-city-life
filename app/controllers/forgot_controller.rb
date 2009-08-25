class ForgotController < ApplicationController
  skip_before_filter :login_required, :login_from_cookie
  
  # shows the email form
  def new
  end

  # post-back action after the email is submitted
  def create
    return unless request.post?
    if @user = User.find_for_forget(params[:email])
      @user.forgot_password
      @user.save
      flash[:notice] = "Instructions to reset your password has been sent to your email address."
      redirect_to new_session_path
    else
      flash[:notice] = "Could not find a user with that email address."
      render :action => 'new'
    end
  end

  # password reset form
  def edit
    reset_code = params[:id]
    unless reset_code
      flash[:notice] = "You're password reset code is invalid.  Please submit your email again."
      render :action => 'new'
      return
    end
    
    @user = User.find_by_password_reset_code(reset_code)
    if !@user
      flash[:notice] = "You're password reset code is invalid.  Please submit your email again."
      redirect_to forgot_path
    end
  end

  # post-back action for password reset form
  def update
    return unless request.post?
    
    reset_code = params[:id]
    unless reset_code
      flash[:notice] = "You're password reset code is invalid.  Please submit your email again."
      render :action => 'new'
      return
    end
    
    @user = User.find_by_password_reset_code(reset_code)
    @user.crypted_password = ""
    
    if param_posted?(:user) && @user.update_attributes(params[:user])
        flash[:notice] = "Your password has been reset."
        redirect_to new_session_path
    else 
      render :action => "edit", :id => reset_code
    end
  end
end
