class UserSessionsController < ApplicationController
  after_filter :set_lockdown_values, :only => :create
  skip_before_filter :check_session
  
  def new
    @user_session = UserSession.new
    flash[:warning] = I18n.t('flash.user_sessions.timeout') if params[:stale]
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    @user_session.session_id = request.session_options[:id]
    if @user_session.save
      flash[:success] = I18n.t('flash.user_sessions.create.success')
      redirect_to home_path
    else
      # Do not use the Authlogic errors (too detailed)
      @user_session.errors.clear
      flash[:failure] = I18n.t('flash.user_sessions.create.failure')
      render :action => :new
    end
  end
  
  def destroy
    session[:latest_search_query] = nil
    session[:latest_tag_search_query] = nil
    session[:latest_full_text_search_query] = nil
    session[:latest_advanced_search_query] = nil
    current_user_session.session_id = request.session_options[:id] unless current_user_session.nil?
    current_user_session.destroy unless current_user_session.nil?
    reset_lockdown_session
    flash[:success] = I18n.t('flash.user_sessions.destroy.success')
    redirect_to login_path
  end

  def access_denied
    if current_user_session
      flash[:warning] = I18n.t('flash.user_sessions.access_denied')
      redirect_to home_path
    else
      redirect_to login_path
    end
  end

  private
  def set_lockdown_values
    if user = @user_session.user
      add_lockdown_session_values(user)
    end
  end
  
end