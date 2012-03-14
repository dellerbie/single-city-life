class IndexController < ApplicationController
  skip_before_filter :login_required, :login_from_cookie
  
  def index
    @users = User.find(:all)
    respond_to do |format|
      format.html
      format.json {
        json = {}
        json[:users] = @users.collect do |user|
          user.to_json
        end
        render :json => json
      }
    end
  end
end
