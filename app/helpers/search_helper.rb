module SearchHelper

  def get_spex_categories
    SpexCategoryItem.to_dropdown
  end

  def get_function_categories
    FunctionCategoryItem.to_dropdown
  end

  def get_function_names_by_category(function_category_item_id)
    FunctionItem.to_dropdown(:value => 'id', :text => 'name', :conditions => ['function_category_items.id = ?', function_category_item_id], :joins => 'INNER JOIN function_category_items ON function_items.function_category_item_id = function_category_items.id', :select => 'function_items.*', :order => 'function_items.name ASC')
  end

  def get_spex_years_by_category(spex_category_item_id)
    SpexItem.to_dropdown(:value => 'id', :text => 'year', :conditions => ['spex_category_items.id = ?', spex_category_item_id], :joins => 'INNER JOIN spex_category_items ON spex_items.spex_category_item_id = spex_category_items.id', :select => 'spex_items.*', :order => 'spex_items.year DESC')
  end

  def get_spex_titles_by_category(spex_category_item_id)
    SpexItem.to_dropdown(:value => 'id', :text => 'title', :conditions => ['spex_category_items.id = ?', spex_category_item_id], :joins => 'INNER JOIN spex_category_items ON spex_items.spex_category_item_id = spex_category_items.id', :select => 'spex_items.*', :order => 'spex_items.title ASC')
  end
end
