ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Login routes
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'

  # UI routes
  map.home '/home', :controller => 'home', :action => 'index'
  map.change_profile '/change_profile', :controller => 'home', :action => 'change_profile'
  map.change_password '/change_password', :controller => 'home', :action => 'change_password'
  map.signup '/signup', :controller => 'signup', :action => 'new'
  map.search '/search', :controller => 'search', :action => 'index'
  map.simple_search '/simple_search', :controller => 'search', :action => 'simple_search'
  map.advanced_search '/advanced_search', :controller => 'search', :action => 'advanced_search'
  map.administration '/administration', :controller => 'administration', :action => 'index'
  map.help '/help', :controller => 'help', :action => 'index'
  map.in_case_of_problems '/in_case_of_problems', :controller => 'help', :action => 'in_case_of_problems'
  map.about '/about', :controller => 'help', :action => 'about'
  map.set_locale '/locale/set', :controller => 'locale', :action => 'set', :method => :get

  # Restful routes
  map.resources :spex_categories
  map.resources :spex
  map.resources :function_categories
  map.resources :functions
  map.resources :news
  map.resources :users, :shallow => true, :member => { :approve => :put, :activate => :put, :deactivate => :put, :reject => :put } do |user|
    user.resources :user_groups, :only => [:index, :show] do |user_group|
      user_group.resources :permissions, :only => [:index, :show]
    end
  end
  map.resources :spexare, :shallow => true do |spexare|
    spexare.resources :memberships
    spexare.resources :cohabitants
    spexare.resources :activities do |activity|
      activity.resource :spex_activity
      activity.resources :function_activities do |function_activity|
        function_activity.resource :actor
      end
    end
  end 
  map.resource :user_session
  map.resources :password_resets
  map.resources :signups, :only => [:new, :create]

  map.root :controller => 'home', :action => 'index'

  # See how all your routes lay out with "rake routes"
  
end
