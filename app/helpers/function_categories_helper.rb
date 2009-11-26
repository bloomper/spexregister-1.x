module FunctionCategoriesHelper
  
  def get_available_function_categories
    FunctionCategory.to_dropdown
  end
  
  def get_available_function_categories_first_empty
    returning function_categories = get_available_function_categories do
      function_categories.insert(0, ['',''])
    end
  end
  
  def get_options_for_select_with_actor_attribute(selected = nil)
    selected, disabled = extract_selected_and_disabled(selected)
    
    options_for_select = get_available_function_categories.inject([]) do |options, element|
      text, value = option_text_and_value(element)
      selected_attribute = ' selected="selected"' if option_value_selected?(value, selected)
      disabled_attribute = ' disabled="disabled"' if disabled && option_value_selected?(value, disabled)
      has_actor_attribute = "' has_actor=\"#{FunctionCategory.find_by_id(value).has_actor}\"'" 
      options << %(<option value="#{html_escape(value.to_s)}"#{selected_attribute}#{disabled_attribute}#{has_actor_attribute}>#{html_escape(text.to_s)}</option>)
    end
    
    options_for_select.join("\n")
  end
  
end
