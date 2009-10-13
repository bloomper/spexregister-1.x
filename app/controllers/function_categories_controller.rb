class FunctionCategoriesController < ApplicationController
  before_filter(:get_function)
  
  def index
    @function_category = @function.function_category
  end
  
  def show
    @function_category = @function.function_category
  end
  
  private
  def get_function
    @function = Function.find(params[:function_id])
  end

end
