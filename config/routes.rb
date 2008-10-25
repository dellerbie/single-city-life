ActionController::Routing::Routes.draw do |map|
  map.root :controller => "index"
  #map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  #map.login '/login', :controller => 'sessions', :action => 'new'
  #map.register '/register', :controller => 'users', :action => 'create'
  #map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil 
  #map.forgot_password '/forgot_password', :controller => 'forgot', :action => 'new'
  
  map.forgot '/forgot', :controller => 'forgot', :action => 'new'
  #map.reset_password '/reset-password/:id', :controller => 'forgot', :action => 'edit'
  
  map.resources :users
  map.resource :session

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
