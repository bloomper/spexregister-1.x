# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  session :session_key => 'spexregister'
  # Need to have it here as well to make the unit tests pass
  GetText.locale = 'sv'
  init_gettext 'spexregister'

  before_filter :require_ssl
  before_filter :set_locale 
  before_filter :update_activity_time, :except => [:session_expiry]
  after_filter :set_charset

  helper_method :get_configuration_item, :session_exists?, :get_user_id_from_session, :get_user_from_session

  def about_open
    if request.xhr?
      render :update do |page|
        page.replace_html 'aboutDialog', :partial => '/shared/about'
        page.visual_effect :fade, 'problemDialog'
        page.visual_effect :fade, 'titleContainer'
        page.visual_effect :fade, 'bodyContainer'
        page.visual_effect :appear, 'aboutDialog'
      end
    end
  end

  def about_close
    if request.xhr?
      render :update do |page|
        page.visual_effect :fade, 'aboutDialog'
        page.visual_effect :appear, 'titleContainer'
        page.visual_effect :appear, 'bodyContainer'
      end
    end
  end

  def in_case_of_problems_open
    if request.xhr?
      render :update do |page|
        page.replace_html 'problemDialog', :partial => '/shared/in_case_of_problems'
        page.visual_effect :fade, 'aboutDialog'
        page.visual_effect :fade, 'titleContainer'
        page.visual_effect :fade, 'bodyContainer'
        page.visual_effect :appear, 'problemDialog'
      end
    end
  end

  def in_case_of_problems_close
    if request.xhr?
      render :update do |page|
        page.visual_effect :fade, 'problemDialog'
        page.visual_effect :appear, 'titleContainer'
        page.visual_effect :appear, 'bodyContainer'
      end
    end
  end

  def update_progress_indicator
    if request.xhr?
      if session[:job_key]
        if MiddleMan.jobs.has_key?(session[:job_key])
          worker = MiddleMan.worker(session[:job_key])
          results = worker.results.to_hash
          session[:job_key] = nil if results[:progress].to_i >= 100 || results[:result].eql?('FAILURE')
          worker.delete if results[:progress].to_i >= 100 || results[:result].eql?('FAILURE')
          render :update do |page|
            page.call('Spexregister.progressPercent', 'progressIndicator', results[:progress])
            if results[:progress].to_i >= 100 && results[:result].eql?('SUCCESS')
              page.hide 'progressIndicator'
              page.replace_html 'messagePane', content_tag('ul', content_tag('li', 'Meddelandet har distribuerats.' ))
              page.show 'messagePane'
              page.visual_effect :highlight, 'messagePane', { :startcolor => "'#7e93aa'", :endcolor => "'#39597d'" }
            elsif results[:result].eql?('FAILURE')
              page.hide 'progressIndicator'
              page.replace_html 'errorPane', content_tag('ul', content_tag('li', "Kunde inte distribuera meddelandet. Var god försök senare eller skicka ett mail till #{auto_link(get_configuration_item(ConfigurationItem::ADMIN_MAIL_ADDRESS))} angående felet."))
              page.show 'errorPane'
              page.visual_effect :highlight, 'errorPane', { :startcolor => "'#7e93aa'", :endcolor => "'#39597d'" }
            end
          end
        else
          render :update do |page|
            page.hide 'progressIndicator'
            page.replace_html 'errorPane', content_tag('ul', content_tag('li', "Kunde inte distribuera meddelandet. Var god försök senare eller skicka ett mail till #{auto_link(get_configuration_item(ConfigurationItem::ADMIN_MAIL_ADDRESS))} angående felet."))
            page.show 'errorPane'
            page.visual_effect :highlight, 'errorPane', { :startcolor => "'#7e93aa'", :endcolor => "'#39597d'" }
          end
        end
      else
        render :nothing => true
      end
    end
  end

  protected
    def set_locale
      GetText.locale = 'sv'
    end

    def set_charset
      content_type = headers["Content-Type"] || 'text/html'
      if /^text\//.match(content_type)
        headers["Content-Type"] = "#{content_type}; charset=utf-8"
      end
    end
  
    def redirect_to_index(message = nil, error = false)
      if error && message
        flash[:error] = message
      elsif message
        flash[:message] = message
      end
      redirect_to :controller => '/home', :action => :index
    end
  
    def require_ssl
      if !request.ssl? && [request.remote_addr, request.remote_ip] != ['127.0.0.1'] * 2 && [request.remote_addr, request.remote_ip] != ['0.0.0.0'] * 2
        redirect_to :protocol => 'https://'
      end
    end
  
    def update_activity_time
      session[:expires_at] = 30.minutes.from_now
    end
  
    def session_expiry
      @time_left = (session[:expires_at] - Time.now).to_i
      if @time_left <= 0
        reset_session
        render :template => '/home/redirect_to_login', :layout => false
      else
        render :nothing => true
      end
    end
  
    def rescue_action_in_public(exception)
      case exception
        when ::ActiveRecord::RecordNotFound, ::ActionController::UnknownAction then
          render :file => '404.rhtml', :layout => true, :use_full_path => true, :status => 404
        else
          render :file => '500.rhtml', :layout => true, :use_full_path => true, :status => 500, :locals => { :error_message => exception }
        end
    end
  
    def local_request?
      false
    end
  
    def get_configuration_item(name)
      $config ||= ConfigurationManager.new
      $config[name]
    end
  
    def session_exists?
      session[:user_item_id]
    end
    
    def get_user_id_from_session
      session[:user_item_id]
    end
  
    def get_user_from_session
      UserItem.find(session[:user_item_id])
    end
end
