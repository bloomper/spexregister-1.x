class AdvancedSearchController < ApplicationController
  helper_method :get_available_reports
  YES = AVAILABLE_LOCALES.map { |locale| I18n.t('views.base.yes', :locale => locale[0]) }

  def new
    session[:latest_advanced_search_query] = nil
  end

  def index
    params[:order] ||= "score desc"
    @search_result = Sunspot.search(Spexare) do 
      adjust_solr_params do |p|
        p[:q] = params[:query]
      end
      with(:publish_approval, YES) unless current_user_is_admin?
      order_by params[:order].split(' ').first.to_sym, params[:order].split(' ').last.to_sym
      paginate :page => params[:page], :per_page => ApplicationConfig.entities_per_page
    end
    session[:latest_advanced_search_query] = params
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
