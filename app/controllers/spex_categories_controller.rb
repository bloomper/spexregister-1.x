class SpexCategoriesController < ApplicationController
  inherit_resources

  def new
    new! do |format|
      format.html { render :action => :new, :layout => false }
    end
  end

  protected
  def resource
    @spex_category ||= end_of_association_chain.find_by_id(params[:id])
  end  
  
  def collection
    base_scope = end_of_association_chain
    @search = base_scope.search(params[:search])
    @search.order ||= "ascend_by_name"
    
    @spex_categories ||= @search.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
  end

end
