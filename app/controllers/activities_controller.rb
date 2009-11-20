class ActivitiesController < ApplicationController
  inherit_resources
  actions :all, :except => [:show, :edit, :update]
  respond_to :html
  belongs_to :spexare
  before_filter :resource, :only => [:selected]

  def new
    new! do |format|
      set_available_activities
      format.html { render :layout => false }
    end
  end

  def selected
    @activities = @spexare.activities
  end

  protected
  def resource
    @activity ||= end_of_association_chain.find_by_id(params[:id])
  end  

  def collection
    @activities ||= end_of_association_chain.find(:all)
  end

  private 
  def set_available_activities
     @available_memberships = Membership.get_years(kind.to_i).dup
     @spexare.memberships.by_kind(kind).each do |membership|
       @available_memberships.delete_if {|year| membership.year == year.to_s}
     end
  end

end
