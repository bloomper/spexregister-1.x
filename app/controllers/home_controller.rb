class HomeController < ApplicationController

  def index
    @news_items = News.descend_by_publication_date.paginate :page => params[:page], :per_page => ApplicationConfig.latest_news_per_page
  end
  
end
