class StatisticsReportsController < ApplicationController
  
  def create
    @report = Object.const_get(params[:report].camelize).new
    @report.generate_report_data!
    
    respond_to do |format|
      format.js
    end
  end
  
end