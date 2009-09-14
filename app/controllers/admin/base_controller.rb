class Admin::BaseController < ApplicationController  
  include LoginSystem

  before_filter :require_login

  protected
    def authorize?(user_item)
       if user_item.is_in_role?(RoleItem::ADMIN)
         return true
       else
         return false
       end
    end
  
    def access_denied
      if session_exists?
        redirect_to_index('Du har ej rättigheter till att utföra detta.', true)
      else
        redirect_to :controller => '/home', :action => :login
      end
    end

    def filter_options
      @filter_options = FilterOptions.new(params[:filter_options])
    end
end
