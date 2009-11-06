class Search
  attr_reader :spex_category_id

  def new
    Spexare.new_search
  end
end
