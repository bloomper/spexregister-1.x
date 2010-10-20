# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotification::Notifiable
  helper :all # include all helpers, all the time
  helper_method :current_user_session, :current_user, :logged_in?, :current_user_is_admin?, :current_protocol, :filter_url_if_not_compatible_with, :show_search_result_back_links?, :previous_page, :current_page, :latest_search_query_exists?, :latest_search_query, :latest_advanced_search_query_exists?, :latest_advanced_search_query, :get_available_dashboard_reports
  
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from log
  filter_parameter_logging :password, :password_confirmation
  
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from ActionController::RoutingError, :with => :page_not_found
  rescue_from ActionController::InvalidAuthenticityToken, :with => :internal_error
  rescue_from WillPaginate::InvalidPage, :with => :page_not_found
  
  before_filter :set_locale
  before_filter :check_session
  
  protected
  def set_locale
    locale = session[:locale] || I18n.default_locale
    locale = AVAILABLE_LOCALES.keys.include?(locale) ? locale : I18n.default_locale
    I18n.locale = locale
  end

  def remember_session
    add_lockdown_session_values(@current_user) if current_user && !session[:access_rights]
  end

  def check_session
    sess = current_user_session
    if sess && sess.stale?
      reset_lockdown_session
      session[:latest_search_query] = nil
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
  
  def internal_error
    flash[:warning] = t 'views.base.internal_error'
    redirect_to home_path
  end
  
  def store_location
    if is_storeable_method?(request.method) && is_xhr_storeable?(request.xhr?) && is_storeable_location?(session[:thispage])
      session[:prevpage] = session[:thispage] || ''
      session[:thispage] = sent_from_uri
    end
  end
  
  def is_storeable_method?(method)
    method == :get
  end
  
  def is_xhr_storeable?(xhr)
    return xhr ? false : true
  end
  
  def is_storeable_location?(uri)
    uri != sent_from_uri
  end
  
  def sent_from_uri
    request.request_uri
  end

  def redirect_back_or_default(default)
    if session[:prevpage].nil? || session[:prevpage].blank?
      redirect_to default
    else
      redirect_to filter_url_if_not_compatible_with(session[:prevpage], default)
    end
  end
  
  def filter_url_if_not_compatible_with(url, default, allow_search_urls = false)
    if allow_search_urls && url.match('search')
      return url
    end
    uri = URI.parse(url)
    default_uri = URI.parse(default)
    if uri.path == default_uri.path || (uri.path.split('/').length == default_uri.path.split('/').length && uri.path.split('/').last == default_uri.path.split('/').last)
      return url
    else
      return default
    end
  end

  def show_search_result_back_links?
    false
  end

  def current_page
    session[:thispage]
  end
  
  def previous_page
    session[:prevpage]
  end
  
  def latest_search_query_exists?
    !latest_search_query.blank?
  end

  def latest_search_query
    session[:latest_search_query]
  end

  def latest_advanced_search_query_exists?
    !latest_advanced_search_query.blank?
  end

  def latest_advanced_search_query
    session[:latest_advanced_search_query]
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
  
  def current_protocol
    return request.ssl? ? 'https://' : 'http://'
  end

  def get_available_dashboard_reports
    reports = Rails.cache.read("dashboard_reports_#{I18n.locale}")
    if reports.nil? || Rails.env.development?
      reports = []
      reports_path = Dir[File.join("#{RAILS_ROOT}", 'app', 'dashboard_reports', '*.{rb}')]
      reports_path.flatten.each do |report|
        file_name = File.basename(report, File.extname(report))
        reports << {:key => file_name, :title => t("views.dashboard_report.#{file_name}.title")} unless file_name.include? 'base' 
      end
      reports.sort!{|a, b| a[:title] <=> b[:title]}
      Rails.cache.write("dashboard_reports_#{I18n.locale}", reports)
    end
    return reports
  end

end
