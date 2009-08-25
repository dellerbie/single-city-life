class ProfilesController < ApplicationController
  
  def show
    @user = User.find_by_login(params[:user_id])
    unless @user.profile.completed?
      #flash[:notice] = "#{@user.login} has not completed a profile yet."
      #redirect_to root_path
      if @user = current_user
        redirect_path = edit_user_profile_path
        notice = "Get started and fill out your profile."
      else 
        notice = "#{@user.login} has not completed a profile yet."
        redirect_path = root_path
      end
      flash[:notice] = notice
      redirect_to redirect_path
    end
  end
  
  def edit
    @profile = current_user.profile
  end
  
  def update
    @profile = current_user.profile
    if @profile.update_attributes(params[:profile].merge(:completed => true))
      flash[:notice] = "Your profile has been updated."
      redirect_to user_profile_path(current_user)
    else
      render :action => :edit
    end
  end
end
