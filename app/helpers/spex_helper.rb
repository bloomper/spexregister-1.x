module SpexHelper

  def get_spex_categories
    SpexCategory.to_dropdown
  end

end
