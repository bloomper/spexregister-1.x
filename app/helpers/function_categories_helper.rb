module FunctionCategoriesHelper

  def get_available_function_categories
    FunctionCategory.to_dropdown
  end

  def get_available_function_categories_first_empty
    function_categories = get_available_function_categories
    function_categories.insert(0, ['',''])
  end

end
