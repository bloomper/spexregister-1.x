module FunctionsHelper

  def get_function_categories
    FunctionCategory.to_dropdown
  end

end
