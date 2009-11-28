module SpexCategoriesHelper

  def get_available_spex_categories
    SpexCategory.to_dropdown
  end

  def get_spex_category_years
    SpexCategory.get_years.reverse
  end

  def get_spex_category_name(id)
    SpexCategory.find_by_id(id).name
  end
end
