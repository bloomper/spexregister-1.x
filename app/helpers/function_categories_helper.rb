module FunctionCategoriesHelper
  
  def get_available_function_categories
    FunctionCategory.to_dropdown
  end
  
  def options_for_select_with_has_actor_attribute(selected = nil)
    selected, disabled = extract_selected_and_disabled(selected)
    
    available_function_categories = FunctionCategory.by_name.map { |f| [f.name, f.has_actor, f.id]}
    available_function_categories.insert(0, ['', '', ''])
    
    options_for_select = available_function_categories.inject([]) do |options, element|
      text, value = option_text_and_value(element)
      selected_attribute = ' selected="selected"' if option_value_selected?(value, selected)
      disabled_attribute = ' disabled="disabled"' if disabled && option_value_selected?(value, disabled)
      has_actor_attribute = "' has_actor=\"#{element[1]}\"'" 
      options << %(<option value="#{html_escape(value.to_s)}"#{selected_attribute}#{disabled_attribute}#{has_actor_attribute}>#{html_escape(text.to_s)}</option>)
    end
    
    options_for_select.join("\n").html_safe
  end
  
end
