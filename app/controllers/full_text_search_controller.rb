class FullTextSearchController < ApplicationController
  helper_method :get_available_reports
  YES = AVAILABLE_LOCALES.map { |locale| I18n.t('views.base.yes', :locale => locale[0]) }
  NO = AVAILABLE_LOCALES.map { |locale| I18n.t('views.base.no', :locale => locale[0]) }
  
  def new
    session[:latest_full_text_search_query] = nil
  end

  def index
    params[:order] ||= "score desc"
    deceased = params[:include_deceased].nil? ? NO : YES + NO
    include_not_published = params[:include_not_published].nil? ? YES : YES + NO 
    @search_result = Sunspot.search(Spexare) do 
      fulltext params[:query], :highlight => true
      paginate :page => params[:page], :per_page => ApplicationConfig.entities_per_page
      with(:deceased, deceased)
      with(:publish_approval, include_not_published)
      order_by params[:order].split(' ').first.to_sym, params[:order].split(' ').last.to_sym
      facet(:facet_spex_categories, :sort => :index)
      facet(:facet_spex_years, :sort => :index)
      facet(:facet_spex_titles, :sort => :index)
      facet(:facet_function_categories, :sort => :index)
      facet(:facet_function_names, :sort => :index)
      if params[:facet_spex_categories].present?
        with(:facet_spex_categories).all_of(params[:facet_spex_categories])
      end
      if params[:facet_spex_years].present?
        with(:facet_spex_years).all_of(params[:facet_spex_years])
      end
      if params[:facet_spex_titles].present?
        with(:facet_spex_titles).all_of(params[:facet_spex_titles])
      end
      if params[:facet_function_categories].present?
        with(:facet_function_categories).all_of(params[:facet_function_categories])
      end
      if params[:facet_function_names].present?
        with(:facet_function_names).all_of(params[:facet_function_names])
      end
    end
    session[:latest_full_text_search_query] = params
  end

  def destroy
    session[:latest_full_text_search_query] = nil
    redirect_to new_full_text_search_url
  end

  private
  def get_available_reports
    [{:key => 'address_labels', :title => t('views.report.address_labels.title')}, {:key => 'detail_list', :title => t('views.report.detail_list.title')}, {:key => 'email_address_detail_list', :title => t('views.report.email_address_detail_list.title')}, {:key => 'address_detail_list', :title => t('views.report.address_detail_list.title')}]
  end

end
