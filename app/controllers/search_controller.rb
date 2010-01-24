class SearchController < ApplicationController
  inherit_resources
  respond_to :html, :only => [:new, :index, :destroy]
  defaults :resource_class => Spexare, :collection_name => 'search_result', :route_collection_name => 'search_index', :route_instance_name => 'spexare'

  def destroy
    session[:latest_search_query] = nil
    redirect_to new_search_url
  end

  protected
  def collection
    base_scope = end_of_association_chain
    @search = base_scope.search(params[:search])
    @search.order ||= "ascend_by_last_name"
    
    @search_result ||= @search.find(:all, :select => 'DISTINCT spexare.id, spexare.last_name, spexare.first_name, spexare.nick_name').paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)

    session[:latest_search_query] = params
  end

end
