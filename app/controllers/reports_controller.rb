class ReportsController < ApplicationController
  
  def new
    @report = Object.const_get(params[:report].camelize + 'Report').new
    respond_to do |format|
      format.html { render :action => :new, :layout => false }
    end
  end

  def create
  end
  
end