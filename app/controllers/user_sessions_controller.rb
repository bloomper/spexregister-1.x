class UserSessionsController < ApplicationController
  after_filter :set_lockdown_values, :only => :create
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = I18n.t('views.base.login_successful')
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    reset_lockdown_session
    flash[:notice] = I18n.t('views.base.logout_successful')
    redirect_back_or_default new_user_session_url
  end
  
  private
  def set_lockdown_values
    if user = @user_session.user
      add_lockdown_session_values(user)
    end
  end
  
end