# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include SslRequirement
  helper :all # include all helpers, all the time
  helper_method :current_user_session, :current_user, :logged_in?, :current_user_is_admin?
  
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from log
  filter_parameter_logging :password, :password_confirmation
  
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from ActionController::RoutingError, :with => :page_not_found

  before_filter :set_locale
  before_filter :check_session
  
  ssl_required
  
  protected
  def set_locale
    locale = session[:locale] || I18n.default_locale
    locale = AVAILABLE_LOCALES.keys.include?(locale) ? locale : I18n.default_locale
    I18n.locale = locale
  end
  
  def check_session
    sess = current_user_session
    if sess && sess.stale?
      reset_lockdown_session
      redirect_to login_url(:stale => true)
      return false
    end
  end
  
  def default_url_options(options={})
    { :locale => I18n.locale }
  end
  
  def clear_authlogic_session
    sess = current_user_session
    sess.destroy if sess
  end
  
  def record_not_found
    flash[:warning] = t 'views.base.record_not_found'
    redirect_to home_path
  end
  
  def page_not_found
    flash[:warning] = t 'views.base.page_not_found'
    redirect_to home_path
  end

  private
  def current_user_session
    if defined?(@current_user_session) && !@current_user_session.nil?
      return @current_user_session
    end
    @current_user_session = UserSession.find
  end
  
  def current_user
    if defined?(@current_user) && !@current_user.nil?
      return @current_user
    end
    @current_user = current_user_session && current_user_session.user
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
