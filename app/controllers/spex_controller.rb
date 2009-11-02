class SpexController < ApplicationController
  inherit_resources
  respond_to :html, :except => :destroy
  respond_to :js, :only => :destroy
  defaults :collection_name => 'spex_items', :route_collection_name => 'spex_index'

  def new
    new! do |format|
      format.html { render :action => :new, :layout => false }
    end
  end

  def create
    create! do |success, failure|
      success.html { redirect_to spex_index_url }
    end
  end
  
  def update
    update! do |success, failure|
      success.html { redirect_to spex_index_url }
    end
  end

  protected
  def resource
    @spex ||= end_of_association_chain.find_by_id(params[:id])
  end  
  
  def collection
    base_scope = end_of_association_chain
    @search = base_scope.search(params[:search])
    @search.order ||= "ascend_by_year"
    
    @spex_items ||= @search.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
  end
  
end
