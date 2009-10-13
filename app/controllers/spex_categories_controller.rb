class SpexCategoriesController < ApplicationController
  before_filter(:get_spex)
  
  def index
    @spex_category = @spex.spex_category
  end
  
  def show
    @spex_category = @spex.spex_category
  end
  
  private
  def get_spex
    @spex = Spex.find(params[:spex_id])
  end

end
