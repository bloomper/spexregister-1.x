class Admin::NewsItemController < Admin::BaseController
  include SortHelper
  helper :sort
  uses_tiny_mce(:options => {:theme => 'simple',
  :language => 'sv_utf8',
  :browsers => %w{msie gecko opera}},
  :only => [:new, :edit, :show])
  
  before_filter :filter_options

  def index
    list
    render :action => :list
  end

  def list
    sort_init 'publication_date'
    sort_update
    options = {:page => {:size => params[:hits_per_page].blank? ? get_configuration_item(ConfigurationItem::DEFAULT_LISTING_PAGE_SIZE).to_i : params[:hits_per_page].to_i, :current => params[:page]}, :order => sort_clause, :select => 'news_items.id, news_items.publication_date, news_items.subject, news_items.body'}
    if @filter_options.filter?
      options.merge! :conditions=> ['news_items.publication_date LIKE ? OR news_items.subject LIKE ? OR news_items.body LIKE ?', "%#{@filter_options.filter}%", "%#{@filter_options.filter}%", "%#{@filter_options.filter}%"]
    end
    @news_items = NewsItem.find(:all, options)
  end

  def show
    begin
      @news_item = NewsItem.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempted to access invalid news item #{params[:id]}")
      redirect_to_index('Ogiltlig nyhet.', true)
    end
  end

  def new
    @news_item = NewsItem.new(:publication_date => Date.today())
  end

  def create
    if request.post?
      @news_item = NewsItem.new(params[:news_item])
      if @news_item.save
        redirect_to_index('Nyheten har skapats.')
      else
        @item = @news_item
        render :action => :new
      end
    end
  end

  def edit
    begin
      @news_item = NewsItem.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempted to edit invalid news item #{params[:id]}")
      redirect_to_index('Ogiltlig nyhet.', true)
    end
  end

  def update
    if request.post?
      begin
        @news_item = NewsItem.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        logger.error("Attempted to update invalid news item #{params[:id]}")
        redirect_to_index('Ogiltlig nyhet.', true)
      else
        begin
          if @news_item.update_attributes(params[:news_item])
            redirect_to_index('Nyheten har uppdaterats.')
          else
            @item = @news_item
            render :action => :edit
          end
        rescue ActiveRecord::StaleObjectError
          logger.error("Attempted to update stale news item #{params[:id]}")
          redirect_to_index('Kunde inte uppdatera nyhet pga oväntat fel.', true)
        end
      end
    end
  end

  def destroy
    if request.post?
      begin
        NewsItem.find(params[:id]).destroy
      rescue ActiveRecord::RecordNotFound
        logger.error("Attempted to destroy invalid news item #{params[:id]}")
        redirect_to_index('Ogiltlig nyhet.', true)
      rescue ActiveRecord::StaleObjectError
        logger.error("Attempted to destroy stale news item #{params[:id]}")
        redirect_to_index('Kunde inte radera nyhet pga oväntat fel.', true)
      else
        redirect_to_index('Nyheten har raderats.')
      end
    end
  end 
end
