class SpexareController < ApplicationController
  inherit_resources
  respond_to :html, :except => [:destroy, :destroy_picture]
  respond_to :js, :only => [:index, :destroy, :destroy_picture]
  defaults :collection_name => 'spexare_items', :route_collection_name => 'spexare_index'
  before_filter :resource, :only => [:destroy_picture]

  helper_method :get_available_reports
  
  def new
    new! do |format|
      format.html { render :action => :new, :layout => false }
    end
  end

  def create
    create! do |success, failure|
      success.html { redirect_to filter_url_if_not_compatible_with(current_page, spexare_index_url) }
    end
  end
  
  def update
    update! do |success, failure|
      success.html { redirect_back_or_default spexare_index_url }
    end
  end
  
  def destroy_picture
    @spexare.picture = nil
    if @spexare.save
      flash.now[:success] = I18n.t('flash.spexare.destroy_picture.success')
    else
      flash.now[:failure] = I18n.t('flash.spexare.destroy_picture.failure')
    end
  end

  protected
  def resource
    @spexare ||= end_of_association_chain.find_by_id(params[:id])
  end  
  
  def collection
    base_scope = end_of_association_chain
    if !current_user_is_admin?
      @search = base_scope.search(params[:search]).publish_approval_equals(true)
    else 
      @search = base_scope.search(params[:search])
    end
    @search.order ||= "ascend_by_last_name"
    
    @spexare_items ||= @search.paginate(:page => params[:page], :per_page => params[:per_page] || ApplicationConfig.entities_per_page)
  end

  def show_search_result_back_links?
    if !previous_page.match('search') && !previous_page.match('tag_search') && !previous_page.match('full_text_search') && !previous_page.match('advanced_search')
      true
    end
  end

  private
  def get_available_reports
    [{:key => 'detailed_summary', :title => t('views.report.detailed_summary.title')}]
  end

end
