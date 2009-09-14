module Admin::FunctionItemHelper

  def get_function_categories
    FunctionCategoryItem.to_dropdown
  end
end
