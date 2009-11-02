class NewsController < ApplicationController
  inherit_resources
  respond_to :html, :except => [:new, :destroy]
  respond_to :js, :only => [:new, :destroy, :show]
  defaults :collection_name => 'news_items', :route_collection_name => 'news_index'

  def new
    @news = News.new :publication_date => Time.now.to_formatted_s(:short_format)
    new!
  end
  
  def create
    create! do |success, failure|
      success.html { redirect_to news_index_url }
    end
  end
  
  def update
    update! do |success, failure|
      success.html { redirect_to news_index_url }
    end
  end

  protected
  def resource
    @news ||= end_of_association_chain.find_by_id(params[:id])
  end  
  
  def collection
    base_scope = end_of_association_chain
    @search = base_scope.search(params[:search])
    @search.order ||= "ascend_by_publication_date"
    
    @news_items ||= @search.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
  end
  
end
