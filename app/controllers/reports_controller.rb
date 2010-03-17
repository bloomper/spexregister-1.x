class ReportsController < ApplicationController
  
  def new
    respond_to do |format|
      format.html { render :action => :new, :layout => false }
    end
  end

  def create
  end
  
end