class UsersController < ApplicationController
  inherit_resources
  respond_to :html, :except => [:new, :destroy]
  respond_to :js, :only => [:new, :destroy]
  before_filter :load_user, :only => [:approve, :activate, :deactivate, :reject]
  auto_complete_for :user, :spexare
  
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
  
  # Note that the following methods are not powered by inherited_resources
  def approve
    if @user
      @user.approve!
      flash.now[:notice] = I18n.t('flash.users.approve.notice')
    else
      flash.now[:error] = I18n.t('flash.users.approve.error')
    end
  end
  
  def activate
    if @user
      @user.activate!
      flash.now[:notice] = I18n.t('flash.users.activate.notice')
    else
      flash.now[:error] = I18n.t('flash.users.activate.error')
    end
  end
  
  def deactivate
    if @user
      @user.deactivate!
      flash.now[:notice] = I18n.t('flash.users.deactivate.notice')
    else
      flash.now[:error] = I18n.t('flash.users.deactivate.error')
    end
  end
  
  def reject
    if @user
      @user.reject!
      flash.now[:notice] = I18n.t('flash.users.reject.notice')
    else
      flash.now[:error] = I18n.t('flash.users.reject.error')
    end
  end
  
  def auto_complete_for_user_spexare
    search = Spexare.search(:first_name_like_or_last_name_like_any => params[:user][:spexare].split(' '))
    search.order ||= "ascend_by_first_name"
    @spexare_full_names = search.all.collect { |spexare| spexare.first_name << (spexare.nick_name.blank? ? "" : " '#{spexare.nick_name}'") << " " << spexare.last_name}
    render :partial => 'auto_complete_for_user_spexare'
  end
  
  protected
  def load_user
    @user = User.find_by_id(params[:id])
  end
  
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