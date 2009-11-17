class RelationshipsController < ApplicationController
  inherit_resources
  actions :all, :only => [ :index, :new, :create ]
  respond_to :html
  belongs_to :spexare
  before_filter :resource, :only => [:selected, :remove]

  # TODO: This controller needs some love...
  
  def new
    new!{ render :layout => false }
  end

  def selected
    @cohabitants = @spexare.spouse
  end

  def create
    Relationship.create(:spexare_source => @spexare, :spexare_target => Spexare.find_by_id(params[:spexare_target_id]))
    @spexare.reload
    @relationships = @spexare.spouse
    render :action => 'selected', :layout => false
  end

  def remove
    @cohabitant.destroy
    @spexare.reload
    @relationships = @spexare.spouse
    render :action => 'selected', :layout => false
  end

  protected
  def resource
    @spouse ||= end_of_association_chain.find(params[:id])
  end  

  def collection
    @relationships ||= end_of_association_chain.find(:all)
  end

end
