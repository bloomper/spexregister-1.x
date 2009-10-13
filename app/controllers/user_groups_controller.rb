class UserGroupsController < ApplicationController
  before_filter(:get_user)

  def index
  end
  
  def show
  end
  
  private
  def get_user
    @user = User.find(params[:user_id])
  end

end
