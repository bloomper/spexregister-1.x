class Admin::FunctionItemController < Admin::BaseController
  include SortHelper
  helper :sort

  before_filter :filter_options

  def index
    list
    render :action => :list
  end

  def list
    sort_init 'name', 'asc', nil, 'function_items', true
    sort_update
    options = {:page => {:size => params[:hits_per_page].blank? ? get_configuration_item(ConfigurationItem::DEFAULT_LISTING_PAGE_SIZE).to_i : params[:hits_per_page].to_i, :current => params[:page]}, :order => sort_clause, :select => 'function_items.id, function_items.name, function_items.function_category_item_id', :joins => 'INNER JOIN function_category_items ON function_items.function_category_item_id = function_category_items.id'}
    if @filter_options.filter?
      options.merge! :conditions=> ['function_items.name LIKE ? OR function_category_items.category_name LIKE ?', "%#{@filter_options.filter}%", "%#{@filter_options.filter}%"]
    end
    @function_items = FunctionItem.find(:all, options)
  end

  def show
    begin
      @function_item = FunctionItem.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempted to access invalid function item #{params[:id]}")
      redirect_to_index('Ogiltlig funktion.', true)
    end
  end

  def new
    @function_item = FunctionItem.new()
  end

  def create
    if request.post?
      @function_item = FunctionItem.new(params[:function_item])
      if @function_item.save
        redirect_to_index('Funktionen har skapats.')
      else
        @item = @function_item
        render :action => :new
      end
    end
  end

  def edit
    begin
      @function_item = FunctionItem.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempted to edit invalid function item #{params[:id]}")
      redirect_to_index('Ogiltlig funktion.', true)
    end
  end

  def update
    if request.post?
      begin
        @function_item = FunctionItem.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        logger.error("Attempted to update invalid function item #{params[:id]}")
        redirect_to_index('Ogiltlig funktion.', true)
      else
        begin
          if @function_item.update_attributes(params[:function_item])
            redirect_to_index('Funktionen har uppdaterats.')
          else
            @item = @function_item
            render :action => :edit
          end
        rescue ActiveRecord::StaleObjectError
          logger.error("Attempted to update stale function item #{params[:id]}")
          redirect_to_index('Kunde inte uppdatera funktion pga oväntat fel.', true)
        end
      end
    end
  end

  def destroy
    if request.post?
      begin
        FunctionItem.find(params[:id]).destroy
      rescue ActiveRecord::RecordNotFound
        logger.error("Attempted to destroy invalid function item #{params[:id]}")
        redirect_to_index('Ogiltlig funktion.', true)
      rescue ActiveRecord::StaleObjectError
        logger.error("Attempted to destroy stale function item #{params[:id]}")
        redirect_to_index('Kunde inte radera funktion pga oväntat fel.', true)
      else
        redirect_to_index('Funktionen har raderats.')
      end
    end
  end
end
