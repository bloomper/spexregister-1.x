module SpexHelper

  def get_spex_years
    Spex.get_years
  end

  def get_spex_years_with_first_empty
    spex_years = Array.new Spex.get_years
    spex_years.insert(0, '')
  end

  def get_spex_years_by_category(category_id)
    spex_years = []
    Spex.by_category(category_id, 'year').each do |spex|
      spex_years << [spex.year, spex.id]
    end
    return spex_years
  end

  def get_spex_years_by_category_first_empty(category_id)
    spex_years = Array.new get_spex_years_by_category(category_id)
    spex_years.insert(0, ['',''])
  end

  def get_spex_titles_by_category(category_id)
    spex_titles = []
    Spex.by_category(category_id, 'title').each do |spex|
      spex_titles << [spex.title, spex.id]
    end
    return spex_titles
  end

  def get_spex_titles_by_category_first_empty(category_id)
    spex_titles = Array.new get_spex_titles_by_category(category_id)
    spex_titles.insert(0, ['',''])
  end

end
