class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  before_filter :login_required 
  
  protect_from_forgery :secret => '_singles_session'
  
  helper :all
  
  protected
  
  def param_posted?(symbol)
    request.post? and params[symbol]
  end
end