module SpexHelper

  def get_spex_years
    Spex.get_years
  end

  def get_spex_years_with_first_empty
    spex_years = Array.new Spex.get_years
    spex_years.insert(0, '')
  end

end
