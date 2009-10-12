class SpexareController < ApplicationController

  def index
    @spexare = Spexare.find(:all)

    respond_to do |format|
      format.html
    end
  end
  
  def show
    @spexare = Spexare.find(params[:id])

    respond_to do |format|
      format.html
    end
  end
  
  def new
    @spexare = Spexare.new

    respond_to do |format|
      format.html
    end
  end
  
  def edit
    @spexare = Spexare.find(params[:id])
  end
  
  def create
    @spexare = Spex.new(params[:spexare])

    respond_to do |format|
      if @spexare.save
        flash[:message] = I18n.t('views.spexare.successful_save')
        format.html { redirect_to(@spexare) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def update
    @spexare = Spexare.find(params[:id])

    respond_to do |format|
      if @spexare.update_attributes(params[:spexare])
        flash[:message] = I18n.t('views.spexare.successful_update')
        format.html { redirect_to(@spexare) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    @spexare = Spexare.find(params[:id])
    @spexare.destroy

    respond_to do |format|
      flash[:message] = I18n.t('views.spexare.successful_destroy')
      format.html { redirect_to(spexare_url) }
    end
  end
  
end
