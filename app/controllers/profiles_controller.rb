class ProfilesController < ApplicationController
  before_filter :login_required
  
  def show
    @user = User.find_by_login(params[:user_id])
    unless @user.profile.completed?
      flash[:notice] = "#{@user.login} has not completed a profile yet."
      redirect_to root_path
    end
  end
  
  def edit
    @profile = current_user.profile
  end
  
  def update
    @profile = current_user.profile
    if @profile.update_attributes(params[:profile])
      flash[:notice] = "Your profile has been updated."
      redirect_to user_profile_path(current_user)
    else
      render :action => :edit
    end
  end
end
