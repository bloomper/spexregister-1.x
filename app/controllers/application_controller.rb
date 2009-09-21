# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  expires_session :time => property(:session_length).minutes, :redirect_to => '/login'
  
  # Scrub sensitive parameters from log
  filter_parameter_logging :password
  
  before_filter :set_locale
  
  protected
  
  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = params[:locale]
  end
  
  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end
  
  def on_expiry
    flash[:notice] = I18n.t "views.base.session_expiry"
  end
  
end
