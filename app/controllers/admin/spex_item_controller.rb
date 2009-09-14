class Admin::SpexItemController < Admin::BaseController
  include SortHelper
  helper :sort

  before_filter :filter_options

  def index
    list
    render :action => :list
  end

  def list
    sort_init 'year', 'asc', nil, 'spex_items', true
    sort_update
    options = {:page => {:size => params[:hits_per_page].blank? ? get_configuration_item(ConfigurationItem::DEFAULT_LISTING_PAGE_SIZE).to_i : params[:hits_per_page].to_i, :current => params[:page]}, :order => sort_clause, :select => 'spex_items.id, spex_items.year, spex_items.title, spex_items.spex_category_item_id', :joins => 'INNER JOIN spex_category_items ON spex_items.spex_category_item_id = spex_category_items.id'}
    if @filter_options.filter?
      options.merge! :conditions=> ['spex_items.year LIKE ? OR spex_items.title LIKE ? OR spex_category_items.category_name LIKE ?', "%#{@filter_options.filter}%", "%#{@filter_options.filter}%", "%#{@filter_options.filter}%"]
    end
    @spex_items = SpexItem.find(:all, options)
  end

  def show
    begin
      @spex_item = SpexItem.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempted to access invalid spex item #{params[:id]}")
      redirect_to_index('Ogiltligt spex.', true)
    end
  end

  def new
    @spex_item = SpexItem.new()
  end

  def create
    if request.post?
      @spex_item = SpexItem.new(params[:spex_item])
      @spex_item.spex_poster_item = SpexPosterItem.new(params[:spex_poster_item]) if !params[:spex_poster_item].blank? && params[:spex_poster_item][:uploaded_data] && params[:spex_poster_item][:uploaded_data].size > 0
      if @spex_item.save
        redirect_to_index('Spexet har skapats.')
      else
        @item = @spex_item
        render :action => :new
      end
    end
  end

  def edit
    begin
      @spex_item = SpexItem.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempted to edit invalid spex item #{params[:id]}")
      redirect_to_index('Ogiltligt spex.', true)
    end
  end

  def update
    if request.post?
      begin
        @spex_item = SpexItem.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        logger.error("Attempted to update invalid spex item #{params[:id]}")
        redirect_to_index('Ogiltligt spex.', true)
      else
        @spex_item.spex_poster_item = SpexPosterItem.new(params[:spex_poster_item]) if !params[:spex_poster_item].blank? && params[:spex_poster_item][:uploaded_data] && params[:spex_poster_item][:uploaded_data].size > 0
        begin
          if @spex_item.update_attributes(params[:spex_item])
            if params[:poster_removed] == 'true'
              @spex_item.spex_poster_item.destroy rescue nil
            end
            redirect_to_index('Spexet har uppdaterats.')
          else
            @item = @spex_item
            render :action => :edit
          end
        rescue ActiveRecord::StaleObjectError
          logger.error("Attempted to update stale spex item #{params[:id]}")
          redirect_to_index('Kunde inte uppdatera spex pga oväntat fel.', true)
        end
      end
    end
  end

  def destroy
    if request.post?
      begin
        SpexItem.find(params[:id]).destroy
      rescue ActiveRecord::RecordNotFound
        logger.error("Attempted to destroy invalid spex item #{params[:id]}")
        redirect_to_index('Ogiltligt spex.', true)
      rescue ActiveRecord::StaleObjectError
        logger.error("Attempted to destroy stale spex item #{params[:id]}")
        redirect_to_index('Kunde inte radera spex pga oväntat fel.', true)
      else
        redirect_to_index('Spexet har raderats.')
      end
    end
  end
end
