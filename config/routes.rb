ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  map.resources :spex do |spex|
    spex.resource :spex_category, :only => [:index, :show]
    spex.resource :poster
  end
  map.resources :functions do |function|
    function.resource :function_category, :only => [:index, :show]
  end
  map.resources :news
  map.resources :users, :shallow => true do |user|
    user.resource :spexare
    user.resources :user_groups, :only => [:index, :show] do |user_group|
      user_group.resources :permissions, :only => [:index, :show]
    end
  end
  map.resources :spexare, :shallow => true do |spexare|
    spexare.resource :user
    spexare.resource :picture
    spexare.resources :achievements do |achievement|
      achievement.resource :spex_achievement
      achievement.resources :function_achievements do |function_achievement|
        function_achievement.resource :actor
      end
    end
  end 
  
  map.resource :user_session
  
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  
  map.root :controller => "user_sessions", :action => "new"
  
  # See how all your routes lay out with "rake routes"
  
end
