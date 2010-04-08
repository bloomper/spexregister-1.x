class ActivitiesController < ApplicationController
  inherit_resources
  actions :all
  respond_to :html, :except => [:show]
  respond_to :js, :only => [:show]
  belongs_to :spexare
  before_filter :resource, :only => [:selected]

  def new
    new! do |format|
      set_available_activities(SpexCategory.find_by_id(params[:spex_category_id]))
      @current_spex_category_id = params[:spex_category_id]
      @show_revivals = false
      format.html { render :layout => false }
    end
  end

  def create
    create! do
      selected_spexare_activities_url(@spexare)
    end
  end

  def edit
    edit! do |format|
      set_available_activities(@activity.spex.spex_category, @activity.spex.id.to_i, @activity.spex.is_revival?)
      @current_spex_category_id = @activity.spex.spex_category.id
      @show_revivals = @activity.spex.is_revival?
      format.html { render :layout => false }
    end
  end

  def update
    update! do
      selected_spexare_activities_url(@spexare)
    end
  end

  def selected
    @activities = @spexare.activities.by_spex_year.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
  end

  def destroy
    destroy! do
      selected_spexare_activities_url(@spexare)
    end
  end

  protected
  def resource
    @activity ||= end_of_association_chain.find_by_id(params[:id])
  end  

  def collection
    @activities ||= end_of_association_chain.by_spex_year.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
  end

  def is_storeable_location?(uri)
    false
  end

  def show_search_result_back_links?
    if !previous_page.match('search') && !previous_page.match('advanced_search')
      true
    end
  end

  private 
  def set_available_activities(spex_category, do_not_delete = nil, show_revivals = false)
    if show_revivals
      @available_activities = Spex.revivals_by_category(spex_category).map(&:id)
    else
      @available_activities = Spex.by_category(spex_category).map(&:id)
    end
    @spexare.activities.by_spex_category(spex_category).each do |activity|
      @available_activities.delete_if {|available_activity| activity.spex.id == available_activity && (do_not_delete.nil? ? true : do_not_delete != available_activity)}
    end
  end

end
