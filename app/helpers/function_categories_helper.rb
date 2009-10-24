module FunctionCategoriesHelper

  def get_available_function_categories
    FunctionCategory.to_dropdown
  end

  def get_available_function_categories_first_empty
    function_categories = Array.new FunctionCategory.to_dropdown
    function_categories.insert(0, ['',''])
  end

end
