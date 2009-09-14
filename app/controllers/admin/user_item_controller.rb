class Admin::UserItemController < Admin::BaseController
  include SortHelper
  helper :sort

  before_filter :filter_options

  def index
    list
    render :action => :list
  end

  def list
    sort_init 'user_name', 'asc', nil, 'user_items', true
    sort_update
    options = {:page => {:size => params[:hits_per_page].blank? ? get_configuration_item(ConfigurationItem::DEFAULT_LISTING_PAGE_SIZE).to_i : params[:hits_per_page].to_i, :current => params[:page]}, :order => sort_clause, :select => 'user_items.*', :joins => 'INNER JOIN role_items ON user_items.role_item_id = role_items.id'}
    if @filter_options.filter?
      options.merge! :conditions=> ['user_items.user_name LIKE ? OR role_items.description LIKE ?', "%#{@filter_options.filter}%", "%#{@filter_options.filter}%"]
    end
    @user_items = UserItem.find(:all, options)
  end

  def show
    begin
      @user_item = UserItem.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempted to access invalid user item #{params[:id]}")
      redirect_to_index('Ogiltlig användare.', true)
    end
  end

  def new
    @user_item = UserItem.new()
  end

  def create
    if request.post?
      @user_item = UserItem.new(params[:user_item])
      if !params[:user_item][:spexare_item_full_name].blank?
        handle_spexare(params[:user_item][:spexare_item_full_name])
      end
      @user_item.role_item = RoleItem.find(params[:user_item][:role_item_id])
      if @user_item.save
        redirect_to_index('Användaren har skapats.')
      else
        @user_item.user_password = nil
        @user_item.user_password_confirmation = nil
        @item = @user_item
        render :action => :new
      end
    end
  end

  def edit
    begin
      @user_item = UserItem.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempted to edit invalid user item #{params[:id]}")
      redirect_to_index('Ogiltlig användare.', true)
    end
  end

  def update
    if request.post?
      begin
        @user_item = UserItem.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        logger.error("Attempted to update invalid user item #{params[:id]}")
        redirect_to_index('Ogiltlig användare.', true)
      else
        if !params[:user_item][:spexare_item_full_name].blank?
          if @user_item.spexare_item.nil? || params[:user_item][:spexare_item_full_name] != @user_item.spexare_item.full_name
            handle_spexare(params[:user_item][:spexare_item_full_name])
          end
        end
        begin
          @user_item.role_item = RoleItem.find(params[:user_item][:role_item_id])
          if @user_item.update_attributes(params[:user_item])
            redirect_to_index('Användaren har uppdaterats.')
          else
            @item = @user_item
            render :action => :edit
          end
        rescue ActiveRecord::StaleObjectError
          logger.error("Attempted to update stale user item #{params[:id]}")
          redirect_to_index('Kunde inte uppdatera användare pga oväntat fel.', true)
        end
      end
    end
  end

  def destroy
    if request.post?
      if get_user_id_from_session.to_i != params[:id].to_i
        begin
          UserItem.find(params[:id]).destroy
        rescue ActiveRecord::RecordNotFound
          logger.error("Attempted to destroy invalid user item #{params[:id]}")
          redirect_to_index('Ogiltlig användare.', true)
        rescue ActiveRecord::StaleObjectError
          logger.error("Attempted to destroy stale user item #{params[:id]}")
          redirect_to_index('Kunde inte radera användare pga oväntat fel.', true)
        else
          redirect_to_index('Användaren har raderats.')
        end
      else
        redirect_to_index('Du kan inte radera dig själv.', true)
      end
    end
  end

  def auto_complete_for_user_item_spexare_item_full_name
    auto_complete_responder_for_user_item_spexare_item_full_name params[:user_item][:spexare_item_full_name]
  end

  private
    def auto_complete_responder_for_user_item_spexare_item_full_name(full_name)
      @spexare_items = SpexareItem.find_by_full_name(full_name, get_configuration_item(ConfigurationItem::SPEXARE_DROPDOWN_LIST_SIZE))
      render :partial => 'spexare_list'
    end

    def handle_spexare(spexare_item_full_name)
      criteria = spexare_item_full_name.split(' ')
      if criteria.size == 2
        spexare_item = SpexareItem.find_by_first_name_and_last_name(criteria[0], criteria[1])
      elsif criteria.size == 3
        spexare_item = SpexareItem.find_by_first_name_and_last_name_and_nick_name(criteria[0], criteria[2], criteria[1][1, criteria[1].length - 2])
      end
      if spexare_item.nil?
        @user_item.errors.add_to_base("Du måste ange en giltlig spexare i 'Spexare'.")
      else
        @user_item.spexare_item = spexare_item
      end
    end
end
