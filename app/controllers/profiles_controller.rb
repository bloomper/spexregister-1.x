class ProfilesController < ApplicationController
  inherit_resources
  respond_to :html, :only => :edit
  defaults :resource_class => Spexare, :instance_name => 'spexare'

  def edit
    edit! do |format|
      format.html { redirect_to edit_spexare_url(@spexare) }
    end
  end

  protected
  def resource
    @spexare ||= current_user.spexare
  end  

end
