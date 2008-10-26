ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'index'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil 
  map.forgot '/forgot', :controller => 'forgot', :action => 'new'
  
  map.resources :users
  map.resource :session

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
