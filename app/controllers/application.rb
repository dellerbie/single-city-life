class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  helper :all
  
  protected
  
  def param_posted?(symbol)
    request.post? and params[symbol]
  end
end