class AdvancedSearchController < ApplicationController
  helper_method :get_available_reports

  def new
    session[:latest_advanced_search_query] = nil
  end

  def index
    @search_result = Sunspot.search(Spexare) do 
      keywords(params[:query])
      paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
    end 
    session[:latest_search_query] = params[:query]
  end

  def destroy
    session[:latest_advanced_search_query] = nil
    redirect_to new_advanced_search_url
  end

  private
  def get_available_reports
    [{:key => 'address_labels', :title => t('views.report.address_labels.title')}, {:key => 'detail_list', :title => t('views.report.detail_list.title')}, {:key => 'email_address_detail_list', :title => t('views.report.email_address_detail_list.title')}, {:key => 'address_detail_list', :title => t('views.report.address_detail_list.title')}]
  end

end
