class FunctionsController < ApplicationController
  inherit_resources
  respond_to :html
  
  protected
  def resource
    @function ||= end_of_association_chain.find_by_id(params[:id])
  end  
  
  def collection
    base_scope = end_of_association_chain
    logger.debug params[:search]
    @search = base_scope.search(params[:search])
    @search.order ||= "ascend_by_name"
    
    @functions ||= @search.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
  end
  
end
