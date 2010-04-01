class RevivalsController < ApplicationController
  inherit_resources
  actions :all, :only => [ :index ]
  respond_to :html
  belongs_to :spex
  before_filter :resource, :only => [:select, :selected, :available, :remove]

  def available
    set_available_revivals
    render :layout => false
  end
  
  def selected 
    @revivals = @spex.revivals.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
  end
  
  def select
    revival = Spex.create(:year => params[:id], :spex_detail => @spex.spex_detail)
    found_slot = false
    @spex.revivals.each do |existing_revival|
      if revival.year.to_i < existing_revival.year.to_i
        revival.move_to_right_of(existing_revival)
        found_slot = true
        break
      end
    end
    revival.move_to_left_of(@spex.revivals[0]) unless found_slot
    @spex.reload
    @revivals = @spex.revivals.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
    set_available_revivals
    render :action => 'selected', :layout => false
  end

  def remove
    @revival.destroy
    @spex.reload
    @revivals = @spex.revivals.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
    set_available_revivals
    render :action => 'selected', :layout => false
  end

  protected
  def resource
    @revival ||= end_of_association_chain.find_by_id(params[:id])
  end
  
  def collection
    @revivals ||= end_of_association_chain.find(:all).paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
  end

  def is_storeable_location?(uri)
    false
  end

  private 
  def set_available_revivals
    @available_revivals = @spex.get_years_til_now.dup
    @spex.revivals.each do |revival|
      @available_revivals.delete_if {|year| revival.year == year.to_s}
    end
  end
  
end
