class MembershipsController < ApplicationController
  inherit_resources
  actions :all, :except => [:show, :update]
  respond_to :html
  belongs_to :spexare
  has_scope :by_kind

  def new
    new! do |format|
      set_available_memberships(params[:by_kind])
      format.html { render :layout => false }
    end
  end
  
  def create
    create! do |format|
      @memberships = @spexare.memberships.by_kind(params[:by_kind])
      set_available_memberships(params[:by_kind])
      format.html { render :action => 'edit', :layout => false }
    end
  end

  def edit
    edit! do
      @memberships = @spexare.memberships.by_kind(params[:by_kind])
    end
  end

  def destroy
    destroy! do |format|
      @memberships = @spexare.memberships.by_kind(params[:by_kind])
      set_available_memberships(params[:by_kind])
      format.html { render :action => 'edit', :layout => false }
    end
  end
  
  def index
    index! do
      @memberships = @spexare.memberships.by_kind(params[:by_kind])
    end
  end

  protected
  def resource
    @membership ||= end_of_association_chain.find_by_id(params[:id])
  end  

  def collection
    @memberships ||= end_of_association_chain.find(:all)
  end

  private 
  def set_available_memberships(kind)
     @available_memberships = Membership.get_years(kind.to_i).dup
     selected_memberships = []
     @spexare.memberships.by_kind(kind).each do |membership| 
       selected_memberships << membership
     end
     @available_memberships.delete_if {|membership| selected_memberships.include? membership}
  end

end
