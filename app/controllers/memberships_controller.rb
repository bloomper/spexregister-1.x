class MembershipsController < ApplicationController
  inherit_resources
  actions :all, :except => [:show, :edit, :update]
  respond_to :html
  belongs_to :spexare
  has_scope :by_kind
  before_filter :resource, :only => [:selected]
  
  def new
    new! do |format|
      set_available_memberships(params[:by_kind])
      format.html { render :layout => false }
    end
  end
  
  def create
    create! do |format|
      @memberships = @spexare.memberships.by_kind(params[:by_kind]).by_year_desc.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
      flash.discard
      format.html { render :action => 'selected', :layout => false }
    end
  end
  
  def selected
    @memberships = @spexare.memberships.by_kind(params[:by_kind]).by_year_desc.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
  end
  
  def destroy
    destroy! do |format|
      @memberships = @spexare.memberships.by_kind(params[:by_kind]).by_year_desc.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
      flash.discard
      format.html { render :action => 'selected', :layout => false }
    end
  end
  
  def index
    index! do
      @memberships = @spexare.memberships.by_kind(params[:by_kind]).paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
    end
  end
  
  protected
  def resource
    @membership ||= end_of_association_chain.find_by_id(params[:id])
  end  
  
  def collection
    @memberships ||= end_of_association_chain.find(:all).paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
  end

  def is_storeable_location?(uri)
    false
  end

  private 
  def set_available_memberships(kind)
    @available_memberships = Membership.get_years(kind.to_i).dup
    @spexare.memberships.by_kind(kind).each do |membership|
      @available_memberships.delete_if {|year| membership.year == year.to_s}
    end
  end
  
end
