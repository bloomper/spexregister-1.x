class RelationshipsController < ApplicationController
  inherit_resources
  actions :all, :except => [:update]
  respond_to :html, :except => [:create]
  respond_to :js, :only => [:create]
  belongs_to :spexare, :singleton => true
  
  def new
    new! do |format|
      format.html { render :layout => false }
    end
  end
  
  def create
    @spexare = Spexare.find_by_id(params[:spexare_id])
    @spouse = Spexare.find_by_id(params[:relationship][:spouse_id])
    if !@spouse
      flash.now[:failure] = t 'flash.relationships.spexare_not_found'
      return false
    end
    if !@spouse.spouse.nil?
      flash.now[:failure] = t 'flash.relationships.create.failure'
      return false
    end
    create! do
      flash.discard
      @spexare.reload
    end
  end
  
  def destroy
    destroy! do |format|
      flash.discard
      format.html { render :action => 'edit', :layout => false }
    end
  end
  
end
