class UsersController < ApplicationController
  before_filter :login_required, :only => [:show, :edit, :update]
  
  def index
    @users = User.find(:all)
  end
  
  # This show action only allows users to view their own profile
  def show
    @user = current_user
  end

  # render new.rhtml
  def new
    #@user = User.new
    #@user.password = @user.password_confirmation = nil
    #@user.birthdate = nil
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && verify_recaptcha(@user) && @user.save  
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  Please check your email in order to activate your account."
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = User.find(current_user)
    if @user.update_attributes(params[:user])
      flash[:notice] = "User updated"
      redirect_to :action => 'show', :id => current_user
    else
      render :action => 'edit'
    end
  end
  
  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to new_session_path
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, false)
      flash[:notice] = "User disabled"
    else
      flash[:error] = "There was a problem disabling this user."
    end
    redirect_to :action => 'index'
  end
  
  def enable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, true)
      flash[:notice] = "User enabled"
    else
      flash[:error] = "There was a problem enabling this user."
    end
      redirect_to :action => 'index'
  end
end
