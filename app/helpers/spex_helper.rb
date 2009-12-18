module SpexHelper

  def get_spex_by_years(years)
    returning spex_items = Hash.new do
      spex_years = []
      spex_titles = []
      Spex.by_years(years).by_title.each do |spex|
        spex_years << [spex.year_with_revival, spex.id]
        spex_titles << [spex.title_with_revival, spex.id]
      end
      spex_items.store('years', spex_years.sort!)
      spex_items.store('titles', spex_titles)
    end
  end

end
