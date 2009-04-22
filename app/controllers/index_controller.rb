class IndexController < ApplicationController
  skip_before_filter :login_required, :login_from_cookie
  
  def index
    @users = User.find(:all)
  end
end
