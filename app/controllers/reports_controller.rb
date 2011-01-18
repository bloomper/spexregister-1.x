class ReportsController < ApplicationController
  
  def new
    @report = Object.const_get(params[:report].camelize + 'Report').new(:ids => params[:ids])
    respond_to do |format|
      format.html { render :action => :new, :layout => false }
    end
  end

  def create
    @report = Object.const_get(params[:report].camelize + 'Report').new(:ids => params[:ids])
    @report.set_conditions([:include_with_missing_address => params[:include_with_missing_address], :merge_related_with_same_address => params[:merge_related_with_same_address], :include_with_missing_email_address => params[:include_with_missing_email_address]])
    @report.set_permissions([:admin => current_user_is_admin?, :spexare_id => current_user.spexare.nil? ? -1 : current_user.spexare.id])
    # set format
  end
  
end