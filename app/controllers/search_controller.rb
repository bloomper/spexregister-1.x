require 'rails_patch/active_record'

class SearchController < BaseController
  include SortHelper
  helper :sort
  uses_tiny_mce(:options => {:theme => 'advanced',
  :width => '550',
  :height => '250',
  :language => 'sv_utf8',
  :browsers => %w{msie gecko opera},
  :theme_advanced_toolbar_location => "top",
  :theme_advanced_toolbar_align => "center",
  :theme_advanced_resizing => true,
  :theme_advanced_resize_horizontal => false,
  :theme_advanced_buttons1 => %w{formatselect fontselect fontsizeselect bold italic underline strikethrough},
  :theme_advanced_buttons2 => %w{justifyleft justifycenter justifyright indent outdent bullist numlist forecolor backcolor link unlink image undo redo print},
  :theme_advanced_buttons3 => [],
  :plugins => %w{print}},
  :only => [:simple_search_result, :advanced_search_result])
  
  before_filter :filter_options

  def simple_search_result
    if !session[:simple_search_query_joins].blank? && !session[:simple_search_query_conditions].blank?
      sort_init 'last_name'
      sort_update
      @spexare_items = SpexareItem.find(:all, :page => {:size => params[:hits_per_page].blank? ? get_configuration_item(ConfigurationItem::DEFAULT_LISTING_PAGE_SIZE).to_i : params[:hits_per_page].to_i, :current => params[:page]}, :order => sort_clause, :select => 'DISTINCT spexare_items.*', :joins => session[:simple_search_query_joins], :conditions => session[:simple_search_query_conditions], :include => :link_items)
    else
      redirect_to_index('Ogiltligt sökuttryck.', true)
    end
  end

  def simple_search
    if request.post?
      simple_search_query_joins = 'LEFT JOIN link_items ON link_items.spexare_item_id = spexare_items.id '
      simple_search_query_joins << 'LEFT JOIN spex_items ON spex_items.id = link_items.spex_item_id ' unless params[:spex_category_item][:id].eql?('-1')
      simple_search_query_joins << 'LEFT JOIN function_items_link_items ON function_items_link_items.link_item_id = link_items.id LEFT JOIN function_items ON function_items.id = function_items_link_items.function_item_id ' unless params[:function_category_item][:id].eql?('-1')
      session[:simple_search_query_joins] = simple_search_query_joins
      simple_search_query_conditions = '0 = 0 '
      simple_search_query_conditions << ActiveRecord::Base.clean_up_sql(['AND spexare_items.last_name LIKE ? ', params[:last_name]]) if !params[:last_name].blank?
      simple_search_query_conditions << ActiveRecord::Base.clean_up_sql(['AND spexare_items.first_name LIKE ? ', params[:first_name]]) if !params[:first_name].blank?
      simple_search_query_conditions << ActiveRecord::Base.clean_up_sql(['AND spexare_items.nick_name LIKE ? ', params[:nick_name]]) if !params[:nick_name].blank?
      simple_search_query_conditions << ActiveRecord::Base.clean_up_sql(['AND link_items.spex_item_id =  ? ', params[:spex_item][:id]]) unless params[:spex_item].blank? || params[:spex_item][:id].eql?('-1')
      simple_search_query_conditions << ActiveRecord::Base.clean_up_sql(['AND spex_items.spex_category_item_id = ? ', params[:spex_category_item][:id]]) unless params[:spex_category_item].blank? || params[:spex_category_item][:id].eql?('-1')
      simple_search_query_conditions << ActiveRecord::Base.clean_up_sql(['AND function_items_link_items.function_item_id = ? ', params[:function_item][:id]]) unless params[:function_item].blank? || params[:function_item][:id].eql?('-1')
      simple_search_query_conditions << ActiveRecord::Base.clean_up_sql(['AND function_items.function_category_item_id = ? ', params[:function_category_item][:id]]) unless params[:function_category_item].blank? || params[:function_category_item][:id].eql?('-1')
      simple_search_query_conditions << 'AND spexare_items.deceased = 0 ' if params[:include_deceased].blank?
      simple_search_query_conditions << 'AND spexare_items.want_circulars = 1 ' if params[:include_no_circulars].blank?
      simple_search_query_conditions << 'AND spexare_items.publish_approval = 1 ' if params[:include_not_published].blank?
      session[:simple_search_query_conditions] = simple_search_query_conditions
      redirect_to :controller => '/search', :action => :simple_search_result
    end
  end

  def advanced_search_result
    if !session[:advanced_search_query].blank?
      begin
        @spexare_items = SpexareItem.full_text_search(session[:advanced_search_query], {:size => params[:hits_per_page].blank? ? get_configuration_item(ConfigurationItem::DEFAULT_LISTING_PAGE_SIZE).to_i : params[:hits_per_page].to_i, :current => params[:page]})
      rescue Exception
        logger.error("Could not complete search due to #{$!.to_s}")
        redirect_to_index('Oväntat fel inträffade under sökning.', true)
      end
    else
      redirect_to_index('Ogiltligt sökuttryck.', true)
    end
  end

  def advanced_search
    if request.post?
      query = params[:query] || ''
      unless query.blank?
        session[:advanced_search_query] = query
        redirect_to :controller => '/search', :action => :advanced_search_result
      end
    end
  end

  def find_spex_years_by_category
    render(:partial => 'spex_items_years', :locals => { :disabled => false, :spex_category_item_id => params[:spex_category_item_id] })
  end

  def find_spex_titles_by_category
    render(:partial => 'spex_items_titles', :locals => { :disabled => false, :spex_category_item_id => params[:spex_category_item_id] })
  end

  def find_functions_by_category
    render(:partial => 'function_items', :locals => { :disabled => false, :function_category_item_id => params[:function_category_item_id] })
  end

  def advanced_search_help_how
    if request.xhr?
      if params[:operation] == 'open'
        render :update do |page|
          page.replace_html 'advancedSearchHelpHow', :partial => 'advanced_search_help_how_open'
          page.visual_effect :appear, 'advancedSearchHelpHow'
        end
      else
        render :update do |page|
          page.replace_html 'advancedSearchHelpHow', :partial => 'advanced_search_help_how_close'
          page.visual_effect :appear, 'advancedSearchHelpHow'
        end
      end
    end
  end

  def advanced_search_help_fields
    if request.xhr?
      if params[:operation] == 'open'
        render :update do |page|
          page.replace_html 'advancedSearchHelpFields', :partial => 'advanced_search_help_fields_open'
          page.visual_effect :appear, 'advancedSearchHelpFields'
        end
      else
        render :update do |page|
          page.replace_html 'advancedSearchHelpFields', :partial => 'advanced_search_help_fields_close'
          page.visual_effect :appear, 'advancedSearchHelpFields'
        end
      end
    end
  end

  def advanced_search_help_examples
    if request.xhr?
      if params[:operation] == 'open'
        render :update do |page|
          page.replace_html 'advancedSearchHelpExamples', :partial => 'advanced_search_help_examples_open'
          page.visual_effect :appear, 'advancedSearchHelpExamples'
        end
      else
        render :update do |page|
          page.replace_html 'advancedSearchHelpExamples', :partial => 'advanced_search_help_examples_close'
          page.visual_effect :appear, 'advancedSearchHelpExamples'
        end
      end
    end
  end

  private
    def filter_options
      @filter_options = FilterOptions.new(nil)
    end

end
