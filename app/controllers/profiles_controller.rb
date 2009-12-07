class ProfilesController < ApplicationController
  inherit_resources
  respond_to :html, :only => [:edit, :show]
  defaults :resource_class => Spexare, :instance_name => 'spexare'

  def edit
    edit! do |format|
      format.html { render 'spexare/edit', :locals => {:edit_mode => true, :current_action => t('views.base.editing_action'), :current_tab => 'spexare_tab'} }
    end
  end

  def show
    show! do |format|
      format.html { render 'spexare/show', :locals => {:edit_mode => false, :current_action => t('views.base.viewing_action'), :current_tab => 'spexare_tab'} }
    end
  end

  protected
  def resource
    @spexare ||= current_user.spexare
  end  

end
