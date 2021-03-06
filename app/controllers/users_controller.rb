class UsersController < ApplicationController
  inherit_resources
  respond_to :html, :except => :destroy
  respond_to :js, :only => :destroy
  before_filter :resource, :only => [:approve, :activate, :deactivate, :reject]

  def new
    new! do |format|
      format.html { render :action => :new, :layout => false }
    end
  end

  def create
    create! do |success, failure|
      success.html { redirect_to filter_url_if_not_compatible_with(current_page, users_url) }
    end
  end
  
  def update
    update! do |success, failure|
      success.html { redirect_back_or_default users_url }
    end
  end
  
  def approve
    if @user && !@user.spexare.blank?
      @user.approve!
      flash.now[:success] = I18n.t('flash.users.approve.success')
    else
      flash.now[:failure] = I18n.t('flash.users.approve.failure')
    end
  end
  
  def activate
    if @user && !@user.spexare.blank?
      @user.activate!
      flash.now[:success] = I18n.t('flash.users.activate.success')
    else
      flash.now[:failure] = I18n.t('flash.users.activate.failure')
    end
  end
  
  def deactivate
    if @user
      @user.deactivate!
      flash.now[:success] = I18n.t('flash.users.deactivate.success')
    else
      flash.now[:failure] = I18n.t('flash.users.deactivate.failure')
    end
  end
  
  def reject
    if @user
      @user.reject!
      flash.now[:success] = I18n.t('flash.users.reject.success')
    else
      flash.now[:failure] = I18n.t('flash.users.reject.failure')
    end
  end
  
  protected
  def resource
    @user ||= end_of_association_chain.find_by_id(params[:id])
  end  
  
  def collection
    base_scope = end_of_association_chain
    @search = base_scope.search(params[:search])
    @search.order ||= "ascend_by_username"

    @users ||= @search.paginate(:page => params[:page], :per_page => params[:per_page] || ApplicationConfig.entities_per_page)
  end
  
end