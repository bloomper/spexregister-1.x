ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Basic routes
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.set_locale '/locale/set', :controller => 'locale', :action => 'set', :method => :get
  map.access_denied_path '/access_denied', :controller => 'user_sessions', :action => 'access_denied'

  # UI routes
  map.home '/home', :controller => 'home', :action => 'index'
  map.signup '/signup', :controller => 'accounts', :action => 'new'
  map.administration '/administration', :controller => 'administration', :action => 'index'
  map.administration_help '/administration_help', :controller => 'administration', :action => 'help'
  map.help '/help', :controller => 'help', :action => 'index'
  map.in_case_of_problems '/in_case_of_problems', :controller => 'help', :action => 'in_case_of_problems'
  map.about_cookies '/about_cookies', :controller => 'help', :action => 'about_cookies'
  map.about '/about', :controller => 'help', :action => 'about'

  # Restful routes
  map.resources :spex_categories, :member => { :destroy_logo => :get }
  map.resources :spex, :member => { :destroy_poster => :get } do |spex|
    spex.resources :revivals, :only => [:index], :member => { :select => :get, :remove => :get }, :collection => { :available => :get, :selected => :get } 
  end
  map.resources :function_categories
  map.resources :functions
  map.resources :news
  map.resources :users, :member => { :approve => :put, :activate => :put, :deactivate => :put, :reject => :put } do |user|
    user.resources :user_groups, :only => [:index], :member => { :select => :get, :remove => :get}, :collection => { :available => :get, :selected => :get }
  end
  map.resources :spexare, :member => { :destroy_picture => :get } do |spexare|
    spexare.resource :relationship, :except => [:update]
    spexare.resources :memberships, :except => [:show, :edit, :update], :collection => { :selected => :get }
    spexare.resources :activities, :collection => { :selected => :get }
    spexare.resources :taggings, :except => [:show, :edit, :update], :collection => { :selected => :get }
  end 
  map.resource :user_session, :except => [:show, :edit, :update]
  map.resources :password_resets, :except => [:show, :destroy]
  map.resources :search, :only => [:new, :index, :destroy]
  map.resources :tag_search, :only => [:new, :index, :destroy]
  map.resources :advanced_search, :only => [:new, :index, :destroy]
  map.resources :full_text_search, :only => [:new, :index, :destroy]
  map.resource :account, :except => [:destroy, :show]
  map.resource :profile, :only => [:edit]
  map.resource :dashboard_reports, :only => [:create]
  map.resource :reports, :only => [:new, :create]
  map.resource :settings, :only => [:show, :edit, :update]
  map.resources :tags
  
  map.root :controller => 'home', :action => 'index'

  # See how all your routes lay out with "rake routes"
  
end
