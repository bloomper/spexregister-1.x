class SearchController < ApplicationController
  
  def new
  end
  
  def index
    @search = Spexare.search(params[:search])
    @search.order ||= "ascend_by_last_name"
    
    @search_result ||= @search.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
  end
  
end
