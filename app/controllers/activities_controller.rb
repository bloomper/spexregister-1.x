class ActivitiesController < ApplicationController
  inherit_resources
  actions :all
  respond_to :html, :except => [:create, :update, :show]
  respond_to :js, :only => [:create, :update, :show]
  belongs_to :spexare
  before_filter :resource, :only => [:selected]

  def new
    new! do |format|
      @activity.build_spex_activity
      @activity.function_activities.build
      @activity.function_activities.each{|function_activity| function_activity.build_actor}
      set_available_activities(SpexCategory.find_by_id(params[:spex_category_id]))
      format.html { render :layout => false }
    end
  end

  def create
    create! do
      @activities = @spexare.activities.by_spex_year
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
      @activities = @spexare.activities.by_spex_year
      flash.discard
    end
  end

  def selected
    @activities = @spexare.activities.by_spex_year
  end

  def destroy
    destroy! do |format|
      @activities = @spexare.activities
      flash.discard
      format.html { render :action => 'selected', :layout => false }
    end
  end

  protected
  def resource
    @activity ||= end_of_association_chain.find_by_id(params[:id])
  end  

  def collection
    @activities ||= end_of_association_chain.find(:all)
  end

  private 
  def set_available_activities(spex_category)
    @available_activities = (spex_category.first_year.to_i..Time.now.strftime('%Y').to_i).entries.reverse
    @spexare.activities.by_spex_category(spex_category).each do |activity|
      @available_activities.delete_if {|year| activity.spex.year == year.to_s}
    end
  end

end
