class ProfilesController < ApplicationController
  before_filter :login_required
  
  def show
    @user = User.find_by_login(params[:user_id])
    unless @user.profile
      flash[:notice] = "#{@user.login} has not filled out a profile yet."
      redirect_to root_path
    end
  end
  
  def edit
    @profile = current_user.profile || Profile.new
  end
  
  def update
    @profile = current_user.profile
    
    
    
    if current_user.profile.update_attributes(params[:profile])
      flash[:notice] = "Your profile has been updated."
      redirect_to user_profile_path(current_user)
    else
      render :action => :edit
    end
  end
end
