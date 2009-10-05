class SpexController < ApplicationController

  def index
    @spex = Spex.find(:all)

    respond_to do |format|
      format.html
    end
  end
  
  def show
    @spex = Spex.find(params[:id])

    respond_to do |format|
      format.html
    end
  end
  
  def new
    @spex = Spex.new

    respond_to do |format|
      format.html
    end
  end
  
  def edit
    @spex = Spex.find(params[:id])
  end
  
  def create
    @spex = Spex.new(params[:spex])

    respond_to do |format|
      if @spex.save
        flash[:message] = I18n.t('views.spex.successful_save')
        format.html { redirect_to(@spex) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def update
    @spex = Spex.find(params[:id])

    respond_to do |format|
      if @spex.update_attributes(params[:spex])
        flash[:message] = I18n.t('views.spex.successful_update')
        format.html { redirect_to(@spex) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    @spex = Spex.find(params[:id])
    @spex.destroy

    respond_to do |format|
      flash[:message] = I18n.t('views.spex.successful_destroy')
      format.html { redirect_to(spex_url) }
    end
  end
  
end
