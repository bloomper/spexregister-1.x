class NewsController < ApplicationController
  inherit_resources
  respond_to :html
  
  def new
    new! do |format|
      format.html { render :action => :new, :layout => false }
    end
  end
  
  protected
  def resource
    @news ||= end_of_association_chain.find_by_id(params[:id])
  end  
  
  def collection
    base_scope = end_of_association_chain
    @search = base_scope.search(params[:search])
    @search.order ||= "ascend_by_publication_date"
    
    @news ||= @search.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
  end
  
end
