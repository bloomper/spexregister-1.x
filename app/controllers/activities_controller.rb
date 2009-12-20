class ActivitiesController < ApplicationController
  inherit_resources
  actions :all
  respond_to :html, :except => [:create, :update, :show]
  respond_to :js, :only => [:create, :update, :show]
  belongs_to :spexare
  before_filter :resource, :only => [:selected]

  def new
    new! do |format|
      set_available_activities(SpexCategory.find_by_id(params[:spex_category_id]))
      format.html { render :layout => false }
    end
  end

  def create
    create! do
      @activities = @spexare.activities.by_spex_year.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
      flash.discard
    end
  end

  def edit
    edit! do |format|
      set_available_activities(@activity.spex.spex_category)
      format.html { render :layout => false }
    end
  end

  def update
    update! do
      @activities = @spexare.activities.by_spex_year.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
      flash.discard
    end
  end

  def selected
    @activities = @spexare.activities.by_spex_year.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
  end

  def destroy
    destroy! do |format|
      @activities = @spexare.activities.by_spex_year.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
      flash.discard
      format.html { render :action => 'selected', :layout => false }
    end
  end

  protected
  def resource
    @activity ||= end_of_association_chain.find_by_id(params[:id])
  end  

  def collection
    @activities ||= end_of_association_chain.by_spex_year.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
  end

  private 
  def set_available_activities(spex_category)
    @available_activities = Spex.by_category_with_revivals(spex_category).map(&:id)
    @spexare.activities.by_spex_category(spex_category).each do |activity|
      @available_activities.delete_if {|available_activity| activity.spex.id == available_activity}
    end
  end

end
