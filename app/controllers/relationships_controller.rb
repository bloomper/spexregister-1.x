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
    @spouse = Spexare.find_by_id(params[:spouse_id])
    if @spouse
      if !@spouse.spouse
        Relationship.create(:spexare => @spexare, :spouse => @spouse)
        @spexare.reload
      else
        flash.now[:error] = t 'flash.relationships.create.error'
        return false
      end
    else 
      flash.now[:error] = t 'flash.relationships.spexare_not_found'
      return false
    end
  end
  
  def destroy
    @spexare = Spexare.find_by_id(params[:spexare_id])
    @spexare.relationship.destroy
  end
  
end
