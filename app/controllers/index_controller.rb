class IndexController < ApplicationController
  skip_before_filter :login_required, :login_from_cookie
  
  def index
    @users = User.paginate  :all, 
                            :page => params[:page] || 1, 
                            :order => 'users.id DESC', 
                            :include => [:profile],
                            :conditions => ['users.enabled = ? and profiles.completed = ?', true, true]
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
      @users = User.paginate :all, :page => 1, :order => 'id DESC', :conditions => ['enabled = ?', true]
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

    age_ranges = get_age_ranges(params[:age_begin], params[:age_end])
    unless age_ranges.empty?
      query.and.birthdate_lte(age_ranges[:age_begin]).birthdate_gte(age_ranges[:age_end])
    end
    
    query.join(:profile)
    query.profile.and.best_feature_in(params[:best_feature]) if params[:best_feature]
    query.profile.and.body_type_in(params[:body_type]) if params[:body_type]
    query.profile.and.ethnicity_in(params[:ethnicity]) if params[:ethnicity]
    users = query.paginate :all, :page => params[:page] || 1, :order => 'users.id DESC', :include => [:profile], :conditions => ['users.enabled = ?', true]

    render :json => get_users_json(users)
  end
  
  private 
  
  def get_users_json(users)
    json = {}
    if users
      json[:totalCount] = users.total_entries
      json[:users] = users.collect do |user|
        puts user.attributes
        user.to_json
      end
    end
    json
  end
  
  def get_age_ranges(age_begin, age_end)
    ranges = {}
    if age_begin && age_end 
      age_begin = age_begin.to_i
      age_end = age_end.to_i
      if((age_begin < age_end) && (age_begin >= 18))
        ranges[:age_begin] = Date.today.years_ago(age_begin).beginning_of_year
        ranges[:age_end] = Date.today.years_ago(age_end).beginning_of_year
      end
    end
    ranges
  end
end
