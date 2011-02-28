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
    # Must reload this one manually
    Sunspot.config.solr.url = Settings['advanced_search.search_engine_url']
    flash[:success] = I18n.t('flash.settings.update.success')
    redirect_to settings_path
  end

end
