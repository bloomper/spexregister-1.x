class UsersController < ApplicationController
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      # TODO Fix me!
      flash[:message] = "Account registered!"
      add_lockdown_session_values
      redirect_to account_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
  end
  
  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user
    if @user.update_attributes(params[:user])
      # TODO Fix me!
      flash[:message] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
  
  def destroy
    if current_user_is_admin?
      user = User.find(params[:id])
      user.destroy
      # TODO Fix me!
      flash[:message] = "User #{user.username} deleted!"
    end
    redirect_to root_path
  end
  
end