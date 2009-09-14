module Admin::SpexItemHelper

  def get_spex_categories
    SpexCategoryItem.to_dropdown
  end
end
