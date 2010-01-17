class SpexareController < ApplicationController
  inherit_resources
  respond_to :html, :except => [:destroy, :destroy_picture]
  respond_to :js, :only => [:index, :destroy, :destroy_picture]
  defaults :collection_name => 'spexare_items', :route_collection_name => 'spexare_index'
  before_filter :resource, :only => [:destroy_picture]

  def new
    new! do |format|
      format.html { render :action => :new, :layout => false }
    end
  end

  def create
    create! do |success, failure|
      success.html { redirect_to spexare_index_url }
    end
  end
  
  def update
    update! do |success, failure|
      success.html { redirect_to spexare_index_url }
    end
  end
  
  def destroy_picture
    @spexare.picture = nil
    if @spexare.save
      flash.now[:success] = I18n.t('flash.spexare.destroy_picture.success')
    else
      flash.now[:failure] = I18n.t('flash.spexare.destroy_picture.failure')
    end
  end

  protected
  def resource
    @spexare ||= end_of_association_chain.find_by_id(params[:id])
  end  
  
  def collection
    base_scope = end_of_association_chain
    if !current_user_is_admin?
      @search = base_scope.search(params[:search]).publish_approval_equals(true)
    else 
      @search = base_scope.search(params[:search])
    end
    @search.order ||= "ascend_by_last_name"
    
    @spexare_items ||= @search.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
  end
  
end
