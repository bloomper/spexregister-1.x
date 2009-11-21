module SpexCategoriesHelper

  def get_available_spex_categories
    SpexCategory.to_dropdown
  end

  def get_available_spex_categories_first_empty
    spex_categories = get_available_spex_categories
    spex_categories.insert(0, ['',''])
  end

  def get_spex_category_years
    SpexCategory.get_years.reverse
  end

  def get_spex_category_years_with_first_empty
    spex_category_years = Array.new get_spex_category_years
    spex_category_years.insert(0, '')
  end

  def get_spex_category_name(id)
    SpexCategory.find_by_id(id).name
  end
end
