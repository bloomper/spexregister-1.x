module SpexCategoriesHelper

  def get_available_spex_categories
    SpexCategory.to_dropdown
  end

  def get_all_spex_categories
    SpexCategory.all
  end

  def get_spex_category_years
    SpexCategory.get_years.reverse.collect! {|y| y.to_s}
  end

  def get_specific_spex_category_years(id)
    SpexCategory.find_by_id(id).get_years_til_now.reverse.collect! {|y| y.to_s}
  end

  def get_spex_category_name(id)
    SpexCategory.find_by_id(id).name
  end
end
