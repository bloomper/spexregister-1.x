class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  
  def new
  end
  
  def edit
  end
  
  def create
    @user = User.find_by_username(params[:username])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = I18n.t("flash.password_resets.create.success")
      redirect_to root_path
    else
      flash[:error] = I18n.t("flash.password_resets.create.failure")
      render :action => :new
    end
  end
  
  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = I18n.t("flash.password_resets.update.success")
      redirect_to home_path
    else
      flash[:notice] = I18n.t("flash.password_resets.update.failure")
      render :action => :edit
    end
  end
  
  private
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:error] = I18n.t("flash.password_resets.token_not_found")
      redirect_to root_path
    end
  end      
  
end
