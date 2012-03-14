ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'index'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil 
  map.forgot '/forgot', :controller => 'forgot', :action => 'new'
  
  map.resources :users, :has_one => :profile, :has_many => :photos
  
  map.resource :session
  
  map.account 'users/:id/account/', :controller => 'account'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect '/.:format', :controller => 'index', :action => 'index'
end
