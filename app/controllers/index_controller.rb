class IndexController < ApplicationController
  skip_before_filter :login_required, :login_from_cookie
  
  def index
    @users = User.paginate :all, :page => params[:page] || 1, :limit => params[:limit], :order => 'id DESC'
    respond_to do |format|
      format.html
      format.json {
        json = {
          :totalCount => @users.total_entries
        }
        
        json[:users] = @users.collect do |user|
          user.to_json
        end
        render :json => json
      }
    end
  end
end
