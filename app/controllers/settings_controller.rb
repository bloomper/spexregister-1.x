class SettingsController < ApplicationController
  
  def show
    render 'general_settings/edit'
  end

  def edit
    render "#{params[:type]}/edit"
  end

  def update
  end

end
