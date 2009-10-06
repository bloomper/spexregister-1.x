class NewsController < ApplicationController

  def index
    @news = News.find(:all)

    respond_to do |format|
      format.html
    end
  end
  
  def show
    @news = News.find(params[:id])

    respond_to do |format|
      format.html
    end
  end
  
  def new
    @news = News.new

    respond_to do |format|
      format.html
    end
  end
  
  def edit
    @news = News.find(params[:id])
  end
  
  def create
    @news = News.new(params[:news])

    respond_to do |format|
      if @news.save
        flash[:message] = I18n.t('views.news.successful_save')
        format.html { redirect_to(@news) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def update
    @news = News.find(params[:id])

    respond_to do |format|
      if @news.update_attributes(params[:news])
        flash[:message] = I18n.t('views.news.successful_update')
        format.html { redirect_to(@news) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    @news = News.find(params[:id])
    @news.destroy

    respond_to do |format|
      flash[:message] = I18n.t('views.news.successful_destroy')
      format.html { redirect_to(news_url) }
    end
  end
  
end
