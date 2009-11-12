module SpexHelper

  def get_spex_years
    Spex.get_years
  end

  def get_spex_years_with_first_empty
    spex_years = Array.new Spex.get_years
    spex_years.insert(0, '')
  end

  def get_spex_by_category(category_id, show_revivals)
    spex_years = []
    spex_titles = []
    Spex.by_category(category_id, show_revivals, 'title').each do |spex|
      spex_years << [spex.year, spex.id]
      spex_titles << [spex.title, spex.id]
    end
    spex_items = Hash.new
    spex_items.store('years', spex_years.sort!)
    spex_items.store('titles', spex_titles)
    return spex_items
  end

  def get_spex_by_category_first_empty(category_id, show_revivals)
    spex_items = get_spex_by_category(category_id, show_revivals)
    spex_items.each { |k, v| spex_items[k] = v.insert(0, ['','']) }
  end

end
