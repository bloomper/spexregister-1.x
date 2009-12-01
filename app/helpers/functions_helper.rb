module FunctionsHelper
  
  def get_functions_by_category(category_id)
    returning function_names = [] do
      Function.by_category(category_id).by_name.each do |function|
        function_names << [function.name, function.id]
      end
    end
  end
  
  def get_function_by_id(id)
    Function.find_by_id(id)
  end
  
end
