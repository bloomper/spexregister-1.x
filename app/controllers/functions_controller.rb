class FunctionsController < ApplicationController

  def index
    @functions = Function.paginate :page => params[:page], :per_page => ApplicationConfig.entities_per_page 

    respond_to do |format|
      format.html
    end
  end
  
  def show
    @function = Function.find(params[:id])

    respond_to do |format|
      format.html
    end
  end
  
  def new
    @function = Function.new

    respond_to do |format|
      format.html
    end
  end
  
  def edit
    @function = Function.find(params[:id])
  end
  
  def create
    @function = Function.new(params[:function])

    respond_to do |format|
      if @function.save
        flash[:message] = I18n.t('views.function.successful_save')
        format.html { redirect_to(@function) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def update
    @function = Function.find(params[:id])

    respond_to do |format|
      if @function.update_attributes(params[:function])
        flash[:message] = I18n.t('views.function.successful_update')
        format.html { redirect_to(@function) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    @function = Function.find(params[:id])
    @function.destroy

    respond_to do |format|
      flash[:message] = I18n.t('views.function.successful_destroy')
      format.html { redirect_to(function_url) }
    end
  end
  
end
