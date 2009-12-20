module SpexHelper

  def get_available_spex_items(ids)
    returning available_spex_items = Hash.new do
      spex_years = []
      spex_titles = []
      Spex.by_ids(ids).by_title.each do |spex|
        spex_years << [spex.year_with_revival, spex.id]
        spex_titles << [spex.title_with_revival, spex.id]
      end
      available_spex_items.store('years', spex_years.sort!)
      available_spex_items.store('titles', spex_titles)
    end
  end

end
