class SearchesController < ApplicationController
  
  def new
  end
  
  def create
  end
  
  def find_functions_by_category
    render :partial => 'functions', :locals => { :function_category_id => params[:function_category_id] }
  end
  
  def find_spex_by_category
    render :partial => 'spex', :locals => { :spex_category_id => params[:spex_category_id], :show_revivals => params[:show_revivals].to_bool }
  end

end
