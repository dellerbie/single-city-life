ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'index'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil 
  map.forgot '/forgot', :controller => 'forgot', :action => 'new'
  
  map.resources :users, :has_one => :profile, :has_many => :photos
  
  map.resources :users do |u|
    u.resources :photos, :member => { :assign_default => :put }
  end
  
  map.resource :session
  
  map.account 'users/:id/account/', :controller => 'account'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
