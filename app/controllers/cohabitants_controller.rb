class CohabitantsController < ApplicationController
  inherit_resources
  actions :all, :only => [ :index ]
  respond_to :html
  belongs_to :spexare
  before_filter :resource, :only => [:select, :selected, :available, :remove]

  def available
    render :layout => false
  end

  def selected
    @cohabitants = @spexare.cohabitant
  end

  def select
    Cohabitant.create(:spexare => @spexare, :spexare_target => Spexare.find_by_id(params[:id]))
    @spexare.reload
    @cohabitants = @spexare.cohabitant
    render :action => 'selected', :layout => false
  end

  def remove
    @cohabitant.destroy
    @spexare.reload
    @cohabitants = @spexare.cohabitant
    render :action => 'selected', :layout => false
  end

  protected
  def resource
    @cohabitant ||= end_of_association_chain.find_by_id(params[:id])
  end  

  def collection
    @cohabitants ||= end_of_association_chain.find(:all)
  end

end
