class SearchesController < ApplicationController

  def new
  end

  def create
  end

  def find_functions_by_category
    render :partial => 'functions', :locals => { :function_category_id => params[:function_category_id] }
  end

  def find_spex_years_by_category
    render :partial => 'spex_years', :locals => { :spex_category_id => params[:spex_category_id] }
  end

  def find_spex_titles_by_category
    render :partial => 'spex_titles', :locals => { :spex_category_id => params[:spex_category_id] }
  end

end
