class SettingsController < ApplicationController
  
  def edit
    render "#{params[:type]}/edit"
  end

  def update
  end

end
