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
    if username.blank?
      @users = User.paginate :all, :page => params[:page] || 1, :limit => params[:limit], :order => 'id DESC'
      json = get_users_json(@users)
      render :json => json
    else
      @user = User.find_by_login(username)
      json = {
        :totalCount => @user ? 1 : 0,
        :users => @user ? [@user.to_json] : []
      }
      render :json => json
    end
  end
  
  def filter
    query = User.query
    query.and.gender_in(params[:gender]) if params[:gender]
    query.and.default_photo_id_is_not_null if params[:has_pic] == 'y'
    query.join(:profile)
    query.profile.and.best_feature_in(params[:best_feature]) if params[:best_feature]
    query.profile.and.body_type_in(params[:body_type]) if params[:body_type]
    query.profile.and.ethnicity_in(params[:ethnicity]) if params[:ethnicity]
    users = query.paginate :page => params[:page] || 1, :limit => params[:limit], :order => 'users.id DESC'

    render :json => get_users_json(users)
  end
  
  private 
  
  def get_users_json(users)
    json = {}
    if users
      json[:totalCount] = users.total_entries
      json[:users] = users.collect do |user|
        user.to_json
      end
    end
    json
  end
end
