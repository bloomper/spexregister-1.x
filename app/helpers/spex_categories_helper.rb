module SpexCategoriesHelper

  def get_available_spex_categories
    SpexCategory.to_dropdown
  end

  def get_available_spex_categories_first_empty
    spex_categories = get_available_spex_categories
    spex_categories.insert(0, ['',''])
  end

end
