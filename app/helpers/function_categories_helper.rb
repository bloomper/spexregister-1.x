module FunctionCategoriesHelper

  def get_available_function_categories
    FunctionCategory.to_dropdown
  end

end
