module SpexCategoriesHelper

  def get_available_spex_categories
    SpexCategory.to_dropdown
  end

  def get_available_spex_categories_first_empty
    spex_categories = Array.new SpexCategory.to_dropdown
    spex_categories.insert(0, ['',''])
  end

end
