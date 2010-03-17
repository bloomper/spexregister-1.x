class SpexController < ApplicationController
  inherit_resources
  respond_to :html, :except => [:destroy, :destroy_poster]
  respond_to :js, :only => [:destroy, :destroy_poster]
  respond_to :json, :only => :index
  defaults :collection_name => 'spex_items', :route_collection_name => 'spex_index'
  before_filter :resource, :only => [:destroy_poster]

  helper_method :get_available_reports

  def new
    new! do |format|
      format.html { render :action => :new, :layout => false }
    end
  end

  def create
    create! do |success, failure|
      success.html { redirect_to filter_url_if_not_compatible_with(current_page, spex_index_url) }
    end
  end
  
  def update
    update! do |success, failure|
      success.html { redirect_back_or_default spex_index_url }
    end
  end

  def index
    index! do |format|
      format.json { render :json => @spex_items.to_json(:only => [:id, :title, :year], :methods => [:year_with_revival, :title_with_revival]) }
    end
  end

  def destroy
    destroy! do |success, failure|
      failure.js { render :status => 409 }
    end
  end

  def destroy_poster
    @spex.poster = nil
    if @spex.save
      flash.now[:success] = I18n.t('flash.spex.destroy_poster.success')
    else
      flash.now[:failure] = I18n.t('flash.spex.destroy_poster.failure')
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
    
    if params[:format] != 'json'
      @spex_items ||= @search.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
    else
      @spex_items ||= @search.all
    end
  end

  private
  def get_available_reports
    [{:key => 'pluton_list', :title => t('views.report.pluton_list.title')}, {:key => 'streck_list', :title => t('views.report.streck_list.title')}]
  end

end
