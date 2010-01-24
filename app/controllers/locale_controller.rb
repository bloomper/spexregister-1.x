class LocaleController < ApplicationController

  def set
    if params[:locale]
      I18n.locale = params[:locale]
      session[:locale] = params[:locale]
      flash[:success] = t 'views.base.language_changed'
    end
    redirect_back_or_default root_path
  end

end
