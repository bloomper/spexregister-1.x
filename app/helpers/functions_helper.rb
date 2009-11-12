module FunctionsHelper

  def get_function_names_by_category(category_id)
    function_names = []
    Function.by_category(category_id, 'name').each do |function|
      function_names << [function.name, function.id]
    end
    return function_names
  end

  def get_function_names_by_category_first_empty(category_id)
    function_names = get_function_names_by_category(category_id)
    function_names.insert(0, ['',''])
  end

end
