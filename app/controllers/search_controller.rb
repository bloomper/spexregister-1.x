class SearchController < ApplicationController
  inherit_resources
  respond_to :html, :only => [:new, :index, :destroy]
  defaults :resource_class => Spexare, :collection_name => 'search_result', :route_collection_name => 'search_index', :route_instance_name => 'spexare'

  helper_method :get_available_reports

  def new
    session[:latest_search_query] = nil
    session[:latest_search_query_ids] = nil
  end

  def destroy
    session[:latest_search_query] = nil
    session[:latest_search_query_ids] = nil
    redirect_to new_search_url
  end

  protected
  def collection
    base_scope = end_of_association_chain
    @search = base_scope.search(params[:search])
    @search.order ||= "ascend_by_last_name"
    
    @search_result ||= @search.find(:all, :select => 'DISTINCT spexare.id, spexare.last_name, spexare.first_name, spexare.nick_name').paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)

    session[:latest_search_query] = params
    session[:latest_search_query_ids] = @search.all.map(&:id).join(',')
  end

  private
  def get_available_reports
    [{:key => 'address_labels', :title => t('views.report.address_labels.title')}, {:key => 'detail_list', :title => t('views.report.detail_list.title')}, {:key => 'email_address_detail_list', :title => t('views.report.email_address_detail_list.title')}, {:key => 'address_detail_list', :title => t('views.report.address_detail_list.title')}]
  end

end
