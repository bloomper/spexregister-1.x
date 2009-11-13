ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Login routes
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'

  # UI routes
  map.home '/home', :controller => 'home', :action => 'index'
  map.change_profile '/change_profile', :controller => 'home', :action => 'change_profile'
  map.change_password '/change_password', :controller => 'accounts', :action => 'edit'
  map.signup '/signup', :controller => 'accounts', :action => 'new'
  map.search '/search', :controller => 'searches', :action => 'new'
  map.advanced_search '/advanced_search', :controller => 'advanced_searches', :action => 'new'
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
  map.resources :users, :member => { :approve => :put, :activate => :put, :deactivate => :put, :reject => :put } do |user|
    user.resources :user_groups, :only => [:index], :member => { :select => :get, :remove => :get}, :collection => { :available => :get, :selected => :get }
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
  map.resource :user_session, :except => [:show, :edit, :update]
  map.resource :password_reset, :except => [:show, :destroy]
  map.resource :search, :only => [:new, :create], :member => { :find_functions_by_category => :get, :find_spex_by_category => :get }
  map.resource :advanced_search, :only => [:new, :create]
  map.resource :account, :except => [:destroy, :show]

  map.root :controller => 'home', :action => 'index'

  # See how all your routes lay out with "rake routes"
  
end
