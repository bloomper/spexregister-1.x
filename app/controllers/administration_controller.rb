class AdministrationController < ApplicationController

  def index
    params[:report] = get_available_dashboard_reports.first[:key] if params[:report].blank?
  end
  
  def help
  end
  
end
