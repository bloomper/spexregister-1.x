class TagsController < ApplicationController
  inherit_resources
  respond_to :html, :except => :destroy 
  respond_to :js, :only => :destroy

  def new
    new! do |format|
      format.html { render :action => :new, :layout => false }
    end
  end

  def create
    create! do |success, failure|
      success.html { redirect_to filter_url_if_not_compatible_with(current_page, tags_url) }
    end
  end
  
  def update
    update! do |success, failure|
      success.html { redirect_back_or_default tags_url }
    end
  end

  def destroy
    destroy! do |success, failure|
      failure.js { render :status => 409 }
    end
  end

  protected
  def resource
    @tag ||= end_of_association_chain.find_by_id(params[:id])
  end  
  
  def collection
    base_scope = end_of_association_chain
    @search = base_scope.search(params[:search])
    @search.order ||= "ascend_by_name"
    
    @tags ||= @search.paginate(:page => params[:page], :per_page => params[:per_page] || ApplicationConfig.entities_per_page)
  end

end
