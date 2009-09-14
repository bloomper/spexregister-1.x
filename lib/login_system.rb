module LoginSystem 
  
  protected
  
  # overwrite this if you want to restrict access to only a few actions
  # or if you want to check if the user has the correct rights  
  # example:
  #
  #  # only allow nonbobs
  #  def authorize?(user_item)
  #    user_item.login != "bob"
  #  end
  def authorize?(user_item)
     true
  end
  
  # overwrite this method if you only want to protect certain actions of the controller
  # example:
  # 
  #  # don't protect the login and the about method
  #  def protect?(action)
  #    if ['action', 'about'].include?(action)
  #       return false
  #    else
  #       return true
  #    end
  #  end
  def protect?(action)
    true
  end
   
  # login_required filter. add 
  #
  #   before_filter :login_required
  #
  # if the controller should be under any rights management. 
  # for finer access control you can overwrite
  #   
  #   def authorize?(user_item)
  # 
  def require_login
    
    if not protect?(action_name)
      return true  
    end

    begin
      if session[:user_item_id] and authorize?(UserItem.find(session[:user_item_id]))
        return true
      end
    rescue ActiveRecord::RecordNotFound
    end
  
    # call overwriteable reaction to unauthorized access
    access_denied
    return false 
  end

  # overwrite if you want to have special behavior in case the user is not authorized
  # to access the current operation. 
  # the default action is to redirect to the login screen
  # example use :
  # a popup window might just close itself for instance
  def access_denied
    redirect_to :controller => '/home', :action => :login
  end  
  
end