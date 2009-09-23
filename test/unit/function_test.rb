require 'test_helper'

class FunctionTest < ActiveSupport::TestCase
  fixtures :functions, :function_categories
  
  def test_ok
    function = Function.create(:name => Time.now, :function_category => function_categories(:function_category))
    assert function.valid?, function.errors.full_messages.join("\n") 
  end
  
  def test_should_not_save_function_with_no_name
    function = Function.new(:name => nil, :function_category => function_categories(:function_category))
    assert(!function.valid?, "Should not save entry unless name has been set")
    assert(function.errors.invalid?(:name), "Expected an error for missing name")
  end
  
  def test_should_not_save_function_with_no_function_category
    function = Function.new(:name => Time.now, :function_category => nil)
    assert(!function.valid?, "Should not save entry unless function category has been set")
    assert(function.errors.invalid?(:function_category), "Expected an error for missing function category")
  end
  
  def test_should_not_save_function_with_invalid_combination
    existing_function = functions(:function)
    function = Function.new(:name => existing_function.name, :function_category => existing_function.function_category)
    assert(!function.valid?, "Should not save entry if an invalid combination has been set")
    assert(function.errors.on_base, "Expected an error for invalid combination")
  end
  
  def test_should_not_update_spex_with_invalid_combination
    existing_function = functions(:function)
    function = Function.create(:name => Time.now, :function_category => function_categories(:function_category))
    assert function.valid?, function.errors.full_messages.join("\n") 
    function.name = existing_function.name
    function.function_category = existing_function.function_category
    function.save
    assert(!function.valid?, "Should not update entry if an invalid combination has been set")
    assert(function.errors.on_base, "Expected an error for invalid combination")
  end
  
  def test_name_with_category
    existing_function = functions(:function)
    assert_equal "#{existing_function.name} (#{existing_function.function_category.name})", existing_function.name_with_category
  end
end