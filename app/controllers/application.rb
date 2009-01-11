class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  before_filter :login_from_cookie
  before_filter :login_required 
  
  helper :all
  
  protected
  
  def param_posted?(symbol)
    request.post? and params[symbol]
  end
end