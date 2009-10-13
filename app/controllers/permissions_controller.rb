class PermissionsController < ApplicationController
  before_filter(:get_user_group)

  def index
  end
  
  def show
  end
  
  private
  def get_user_group
    @user_group = UserGroup.find(params[:user_group_id])
  end

end
