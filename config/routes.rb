ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  map.resources :spex
  map.resources :users
  map.resource :user_session

  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  
  map.root :controller => "user_sessions", :action => "new"

  # See how all your routes lay out with "rake routes"

end
