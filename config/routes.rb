ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'index'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil 
  map.forgot '/forgot', :controller => 'forgot', :action => 'new'
  
  map.resources :users, :has_one => :profile
  map.resources :users do |user|
    user.resources :photos, :member => { :assign_default => :put}, :collection => { :for_user => :get }
    user.resources :messages, :collection => { :inbox => :get, :outbox => :get, :reply => :post }
  end
  
  map.resource :session
  
  map.account 'users/:id/account/', :controller => 'account'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.connect '/:action', :controller => 'index'
  map.connect '/.json', :controller => 'index', :action => 'index', :format => 'json'
end
