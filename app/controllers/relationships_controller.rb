class RelationshipsController < ApplicationController
  inherit_resources
  actions :all, :except => [:update]
  respond_to :html
  belongs_to :spexare, :singleton => true

  def new
    new! do |format|
      format.html { render :layout => false }
    end
  end

  def create
    @spexare = Spexare.find_by_id(params[:spexare_id])
    @spouse = Spexare.find_by_id(params[:spouse_id])
    # TODO: Do some validation
    Relationship.create(:spexare => @spexare, :spouse => @spouse)
    @spexare.reload
    render :action => 'edit', :layout => false
  end

  def destroy
    @spexare = Spexare.find_by_id(params[:spexare_id])
    @spexare.relationship.destroy
    render :action => 'edit', :layout => false
  end

end
