module SpexCategoriesHelper

  def get_available_spex_categories
    SpexCategory.to_dropdown
  end

end
