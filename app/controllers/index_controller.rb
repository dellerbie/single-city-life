class IndexController < ApplicationController
  skip_before_filter :login_required, :login_from_cookie
  
  def index
    @users = User.paginate :all, :page => params[:page] || 1, :limit => params[:limit], :order => 'id DESC'
    respond_to do |format|
      format.html
      format.json {
        render :json => get_users_json(@users)
      }
    end
  end
  
  def find_by_login
    username = params[:username]
    unless username.blank?
      @user = User.find_by_login(username)
      json = {
        :totalCount => @user ? 1 : 0,
        :users => @user ? [@user.to_json] : []
      }
      render :json => json
    else
      @users = User.paginate :all, :page => params[:page] || 1, :limit => params[:limit], :order => 'id DESC'
      json = get_users_json(@users)
      render :json => json
    end
  end
  
  def filter
    
  end
  
  private 
  
  def get_users_json(users)
    json = {
      :totalCount => users.total_entries
    }

    json[:users] = users.collect do |user|
      user.to_json
    end
    
    json
  end
end
