class UsersController < ApplicationController
  inherit_resources
  respond_to :html
  respond_to :js, :only => :destroy

  def new
    new! do |format|
      format.html { render :action => :new, :layout => false }
    end
  end
  
  def create
    create! do |success, failure|
      success.html { redirect_to users_url }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to users_url }
    end
  end
  
  def approve
    @user = User.find_by_id(params[:id])
    @user.approve!
  end

  def activate
    @user = User.find_by_id(params[:id])
    @user.activate!
  end

  def deactivate
    @user = User.find_by_id(params[:id])
    @user.deactivate!
  end

  def reject
    @user = User.find_by_id(params[:id])
    @user.reject!
  end

  protected
  def resource
    @user ||= end_of_association_chain.find_by_id(params[:id])
  end  
  
  def collection
    base_scope = end_of_association_chain
    @search = base_scope.search(params[:search])
    @search.order ||= "ascend_by_username"
    
    @users ||= @search.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
  end

end