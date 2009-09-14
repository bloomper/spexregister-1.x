class Admin::SpexareItemController < Admin::BaseController
  include SortHelper
  helper :sort

  before_filter :filter_options

  def index
    list
    render :action => :list
  end

  def list
    sort_init 'last_name'
    sort_update
    options = {:page => {:size => params[:hits_per_page].blank? ? get_configuration_item(ConfigurationItem::DEFAULT_LISTING_PAGE_SIZE).to_i : params[:hits_per_page].to_i, :current => params[:page]}, :order => sort_clause, :select => 'spexare_items.id, spexare_items.last_name, spexare_items.first_name, spexare_items.nick_name'}
    if @filter_options.filter?
      options.merge! :conditions=> ['spexare_items.last_name LIKE ? OR spexare_items.first_name LIKE ? OR spexare_items.nick_name LIKE ?', "%#{@filter_options.filter}%", "%#{@filter_options.filter}%", "%#{@filter_options.filter}%"]
    end
    @spexare_items = SpexareItem.find(:all, options)
  end

  def show
    begin
      @spexare_item = SpexareItem.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempted to access invalid spexare item #{params[:id]}")
      redirect_to_index('Ogiltlig spexare.', true)
    end
  end

  def new
    @spexare_item = SpexareItem.new()
  end

  def create
    if request.post?
      @spexare_item = SpexareItem.new(params[:spexare_item])
      if !params[:spexare_item][:related_spexare_item_full_name].blank?
        handle_related_spexare(params[:spexare_item][:related_spexare_item_full_name])
      end
      @spexare_item.spexare_picture_item = SpexarePictureItem.new(params[:spexare_picture_item]) if !params[:spexare_picture_item].blank? && params[:spexare_picture_item][:uploaded_data] && params[:spexare_picture_item][:uploaded_data].size > 0
      if @spexare_item.errors.empty?
        if !params[:link_item].blank? && !params[:link_item][:spex_item].blank?
          params[:link_item][:spex_item][:id].size.times do |pos|
            link_item = LinkItem.new
            link_item.spex_item = SpexItem.find(params[:link_item][:spex_item][:id][pos])
            function_item_ids = params[:link_item][:function_item][:id][pos].split(',')
            function_item_ids.size.times do |pos2|
              link_item.function_items << FunctionItem.find(function_item_ids[pos2])
            end
            if !params[:link_item][:actor_item].blank?
              if !params[:link_item][:actor_item][:role][pos].blank? || !params[:link_item][:actor_item][:vocal][pos].blank?
                  actor_item = ActorItem.new
                  actor_item.role = params[:link_item][:actor_item][:role][pos] unless params[:link_item][:actor_item][:role][pos].blank?
                  actor_item.vocal = params[:link_item][:actor_item][:vocal][pos] unless params[:link_item][:actor_item][:vocal][pos].blank?
                  link_item.actor_item = actor_item
              end
            end
            @spexare_item.link_items << link_item
          end
        end
        if @spexare_item.save
          redirect_to_index('Spexaren har skapats.')
        else
          @item = @spexare_item
          render :action => :new
        end
      else
        @item = @spexare_item
        render :action => :new
      end
    end
  end

  def edit
    begin
      @spexare_item = SpexareItem.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempted to edit invalid spexare item #{params[:id]}")
      redirect_to_index('Ogiltlig spexare.', true)
    end
  end

  def update
    if request.post?
      begin
        @spexare_item = SpexareItem.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        logger.error("Attempted to update invalid spexare item #{params[:id]}")
        redirect_to_index('Ogiltlig spexare.', true)
      else
        if !params[:spexare_item][:related_spexare_item_full_name].blank?
          if params[:spexare_item][:related_spexare_item_full_name] != @spexare_item.related_spexare_item_full_name
            @spexare_item.remove_related_spexare
            handle_related_spexare(params[:spexare_item][:related_spexare_item_full_name])
          end
        end
        @spexare_item.spexare_picture_item = SpexarePictureItem.new(params[:spexare_picture_item]) if !params[:spexare_picture_item].blank? && params[:spexare_picture_item][:uploaded_data] && params[:spexare_picture_item][:uploaded_data].size > 0
        begin
          if @spexare_item.errors.empty? && @spexare_item.update_attributes(params[:spexare_item])
            if params[:picture_removed] == 'true'
              @spexare_item.spexare_picture_item.destroy rescue nil
            end
            redirect_to_index('Spexaren har uppdaterats.')
          else
            @item = @spexare_item
            render :action => :edit
          end
        rescue ActiveRecord::StaleObjectError
          logger.error("Attempted to update stale spexare item #{params[:id]}")
          redirect_to_index('Kunde inte uppdatera spexare pga oväntat fel.', true)
        end
      end
    end
  end

  def destroy
    if request.post?
      begin
        if get_user_id_from_session.to_i != SpexareItem.find(params[:id]).user_item.id.to_i
          begin
            SpexareItem.find(params[:id]).destroy
          rescue ActiveRecord::RecordNotFound
            logger.error("Attempted to destroy invalid spexare item #{params[:id]}")
            redirect_to_index('Ogiltlig spexare.', true)
          rescue ActiveRecord::StaleObjectError
            logger.error("Attempted to destroy stale spexare item #{params[:id]}")
            redirect_to_index('Kunde inte radera spexare pga oväntat fel.', true)
          else
            redirect_to_index('Spexaren har raderats.')
          end
        else
          redirect_to_index('Du kan inte radera dig själv.', true)
        end
      rescue ActiveRecord::RecordNotFound
        logger.error("Attempted to destroy invalid spexare item #{params[:id]}")
        redirect_to_index('Ogiltlig spexare.', true)
      end
    end
  end

  def new_link_item
    @link_item = LinkItem.new
  end

  def add_link_item
    if request.post?
      @link_item = LinkItem.new
      begin
        @link_item.spex_item = SpexItem.find(params[:link_item][:spex_item][:id])
      rescue ActiveRecord::RecordNotFound
        logger.error("Attempted to access invalid spex item #{params[:link_item][:spex_item][:id]}")
        send_back_error('Ogiltligt spex.')
      else
        function_item_ids = params[:link_item][:function_items]
        if !function_item_ids.nil?
          function_item_ids.size.times do |pos|
            begin
              @link_item.function_items << FunctionItem.find(function_item_ids[pos])
            rescue ActiveRecord::RecordNotFound
              logger.error("Attempted to access invalid function item #{function_item_ids[pos]}")
              send_back_error('Ogiltlig funktion.')
            end
          end
        end
        if !params[:link_item][:actor_item][:role].blank? || !params[:link_item][:actor_item][:vocal].blank?
          actor_item = ActorItem.new
          actor_item.role = params[:link_item][:actor_item][:role] unless params[:link_item][:actor_item][:role].blank?
          actor_item.vocal = params[:link_item][:actor_item][:vocal] unless params[:link_item][:actor_item][:vocal].blank?
          @link_item.actor_item = actor_item
        end
        if params[:parent_action] == 'edit'
          begin
            @spexare_item = SpexareItem.find(params[:spexare_item_id])
          rescue ActiveRecord::RecordNotFound
            logger.error("Attempted to access invalid spexare item #{params[:spexare_item_id]}")
            send_back_error('Ogiltlig spexare.')
          else
            @link_item.spexare_item = @spexare_item
            @link_item.save
          end
        else
          @link_item.id = params[:link_item_id]
        end
      end
    end
  end

  def edit_link_item
    begin
      @link_item = LinkItem.find(params[:link_item_id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempted to access invalid link item #{params[:link_item_id]}")
      send_back_error('Ogiltlig länk.')
    end
  end

  def update_link_item
    if request.post?
      begin
        @link_item = LinkItem.find(params[:link_item_id])
      rescue ActiveRecord::RecordNotFound
        logger.error("Attempted to access invalid link item #{params[:link_item_id]}")
        send_back_error('Ogiltlig länk.')
      else
        begin
          @link_item.spex_item = SpexItem.find(params[:link_item][:spex_item][:id]) if @link_item.spex_item.id != params[:link_item][:spex_item][:id]
        rescue ActiveRecord::RecordNotFound
          logger.error("Attempted to access invalid spex item #{params[:link_item][:spex_item][:id]}")
          send_back_error('Ogiltligt spex.')
        end
        function_item_ids = params[:link_item][:function_items]
        if !function_item_ids.nil?
          function_item_ids.size.times do |pos|
            begin
              function_item = FunctionItem.find(function_item_ids[pos])
            rescue ActiveRecord::RecordNotFound
              logger.error("Attempted to access invalid function item #{function_item_ids[pos]}")
              send_back_error('Ogiltlig funktion.')
            else 
              if !@link_item.function_items.include?(function_item)
                @link_item.function_items << function_item
              end
            end
          end
          @link_item.function_items.size.times do |pos|
            if !@link_item.function_items[pos].nil? && !function_item_ids.include?(@link_item.function_items[pos].id.to_s)
              @link_item.function_items.delete(@link_item.function_items[pos])
            end
          end
        else
          @link_item.function_items.clear;
          @link_item.actor_item = nil
        end
        if !params[:link_item][:actor_item].blank? && (!params[:link_item][:actor_item][:role].blank? || !params[:link_item][:actor_item][:vocal].blank?)
          if @link_item.actor_item.nil?
            actor_item = ActorItem.new
            actor_item.role = params[:link_item][:actor_item][:role] unless params[:link_item][:actor_item][:role].blank?
            actor_item.vocal = params[:link_item][:actor_item][:vocal] unless params[:link_item][:actor_item][:vocal].blank?
            @link_item.actor_item = actor_item
          else
            @link_item.actor_item.role = params[:link_item][:actor_item][:role]
            @link_item.actor_item.vocal = params[:link_item][:actor_item][:vocal]
          end
        else
          @link_item.actor_item = nil
        end
        begin
          @link_item.save
        rescue ActiveRecord::StaleObjectError
          logger.error("Attempted to update stale link item #{params[:link_item_id]}")
          send_back_error('Kunde inte uppdatera länk pga oväntat fel.')
        end
      end
    end
  end

  def cancel_link_item
  end

  def destroy_link_item
    if request.post?
      if params[:parent_action] == 'edit'
        begin
          LinkItem.find(params[:link_item_id]).destroy
        rescue ActiveRecord::RecordNotFound
          logger.error("Attempted to destroy invalid link item #{params[:link_item_id]}")
          send_back_error('Ogiltlig länk.')
        rescue ActiveRecord::StaleObjectError
          logger.error("Attempted to destroy stale link item #{params[:link_item_id]}")
          send_back_error('Kunde inte radera länk pga oväntat fel.')
        end
      end
    end
  end

  def move_up_link_item
    if request.post?
      if params[:parent_action] == 'edit'
        begin
          LinkItem.find(params[:link_item_id]).move_higher
        rescue ActiveRecord::RecordNotFound
          logger.error("Attempted to move invalid link item #{params[:link_item_id]}")
          send_back_error('Ogiltlig länk.')
        rescue ActiveRecord::StaleObjectError
          logger.error("Attempted to move stale link item #{params[:link_item_id]}")
          send_back_error('Kunde inte flytta länk pga oväntat fel.')
        end
      end
    end
  end

  def move_down_link_item
    if request.post?
      if params[:parent_action] == 'edit'
        begin
          LinkItem.find(params[:link_item_id]).move_lower
        rescue ActiveRecord::RecordNotFound
          logger.error("Attempted to move invalid link item #{params[:link_item_id]}")
          send_back_error('Ogiltlig länk.')
        rescue ActiveRecord::StaleObjectError
          logger.error("Attempted to move stale link item #{params[:link_item_id]}")
          send_back_error('Kunde inte flytta länk pga oväntat fel.')
        end
      end
    end
  end

  def find_spex_years_by_category
    render(:partial => 'spex_items_years', :locals => { :disabled => false, :spex_category_item_id => params[:spex_category_item_id] })
  end

  def find_spex_titles_by_category
    render(:partial => 'spex_items_titles', :locals => { :disabled => false, :spex_category_item_id => params[:spex_category_item_id] })
  end

  def auto_complete_for_spexare_item_related_spexare_item_full_name
    auto_complete_responder_for_spexare_item_related_spexare_item_full_name(params[:spexare_item_related_spexare_item_full_name], params[:spexare_item_id])
  end

  private
    def auto_complete_responder_for_spexare_item_related_spexare_item_full_name(value, exclude)
      @spexare_items = SpexareItem.find_by_full_name(value, get_configuration_item(ConfigurationItem::RELATED_SPEXARE_DROPDOWN_LIST_SIZE), exclude)
      render :partial => 'related_spexare_list'
    end

    def handle_related_spexare(related_spexare_item_full_name)
      criteria = related_spexare_item_full_name.split(' ')
      if criteria.size == 2
        related_spexare_item = SpexareItem.find_by_first_name_and_last_name(criteria[0], criteria[1])
      elsif criteria.size == 3
        related_spexare_item = SpexareItem.find_by_first_name_and_last_name_and_nick_name(criteria[0], criteria[2], criteria[1][1, criteria[1].length - 2])
      end
      if related_spexare_item.nil?
        @spexare_item.errors.add_to_base("Du måste ange en giltlig spexare i 'Gift/sambo med'.")
      else
        begin
          @spexare_item.add_related_spexare(related_spexare_item)
        rescue Exception
          @spexare_item.errors.add_to_base($!.to_s)
        end
      end
    end
    
    def send_back_error(message)
      render :update do |page|
        page.replace_html 'errorPane', content_tag('ul', content_tag('li', message))
        page.show 'errorPane'
        page.visual_effect :highlight, 'errorPane', { :startcolor => "'#7e93aa'", :endcolor => "'#39597d'" }
      end
    end
end
