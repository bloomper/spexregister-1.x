class HomeController < ApplicationController

  def index
    @news_items = News.is_published_is(true).publication_date_lte(Time.now.to_formatted_s(:short_format)).descend_by_publication_date.paginate :page => params[:page], :per_page => ApplicationConfig.latest_news_per_page
  end
  
end
