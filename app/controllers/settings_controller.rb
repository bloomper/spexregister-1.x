class SettingsController < ApplicationController
  
  def edit
    render "#{params[:type]}_settings/edit"
  end

  def update
    params[:settings].each_key do |scope|
      params[:settings][scope].each do |setting, value|
        Settings["#{scope}.#{setting}"] = value
      end
    end
    flash[:success] = I18n.t('flash.settings.update.success')
    redirect_to settings_path
  end

end
