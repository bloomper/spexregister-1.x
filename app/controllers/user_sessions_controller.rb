class UserSessionsController < ApplicationController
  after_filter :set_lockdown_values, :only => :create
  skip_before_filter :check_session
  
  def new
    @user_session = UserSession.new
    flash[:notice] = I18n.t('flash.user_sessions.timeout') if params[:stale]
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = I18n.t('flash.user_sessions.create.success')
      redirect_to home_path
    else
      # Do not use the Authlogic errors (too detailed)
      @user_session.errors.clear
      flash[:error] = I18n.t('flash.user_sessions.create.failure')
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    reset_lockdown_session
    flash[:notice] = I18n.t('flash.user_sessions.destroy.success')
    redirect_to login_path
  end
  
  private
  def set_lockdown_values
    if user = @user_session.user
      add_lockdown_session_values(user)
    end
  end
  
end