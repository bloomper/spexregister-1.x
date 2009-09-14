module Admin::SpexareItemHelper

  def get_spex_years_by_category(spex_category_item_id)
    SpexItem.to_dropdown(:value => 'id', :text => 'year', :conditions => ['spex_category_items.id = ?', spex_category_item_id], :joins => 'INNER JOIN spex_category_items ON spex_items.spex_category_item_id = spex_category_items.id', :select => 'spex_items.*', :order => 'spex_items.year DESC')
  end

  def get_spex_titles_by_category(spex_category_item_id)
    SpexItem.to_dropdown(:value => 'id', :text => 'title', :conditions => ['spex_category_items.id = ?', spex_category_item_id], :joins => 'INNER JOIN spex_category_items ON spex_items.spex_category_item_id = spex_category_items.id', :select => 'spex_items.*', :order => 'spex_items.title ASC')
  end

  def get_spex_categories
    SpexCategoryItem.to_dropdown
  end
  
  def get_functions_with_category_name
    FunctionItem.to_dropdown(:value => 'id', :text => 'name_with_category', :order => 'name ASC')
  end

  def get_actor_vocal_types
    ActorItem::VOCAL_TYPES
  end

  def generate_temporary_id
    (Time.now.to_f*1000).to_i.to_s
  end

  def element_row_id(options)
    "#{options[:action]}-#{options[:link_item_id]}"
  end

  def element_cell_id(options)
    "#{options[:action]}-#{options[:link_item_id]}-cell"
  end

  def element_form_id(options)
    "#{options[:action]}-#{options[:link_item_id]}-form"
  end
end
