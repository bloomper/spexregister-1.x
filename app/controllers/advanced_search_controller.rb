class AdvancedSearchController < ApplicationController

  def new
  end

  def index
  end

  def destroy
    session[:latest_advanced_search_query] = nil
  end

end
