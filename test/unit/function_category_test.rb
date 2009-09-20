require 'test_helper'

class FunctionCategoryTest < ActiveSupport::TestCase
  fixtures :function_categories
  
  def test_ok
    function_category = FunctionCategory.create(:name => Time.now)
    assert function_category.valid?, function_category.errors.full_messages.join("\n") 
  end
  
  def test_should_not_save_function_category_with_no_name
    function_category = FunctionCategory.new(:name => nil)
    assert(!function_category.valid?, "Should not save entry unless name has been set")
    assert(function_category.errors.invalid?(:name), "Expected an error for missing name")
  end
  
  def test_should_not_save_function_category_with_duplicate_name
    existing_function_category = function_categories(:function_category)
    function_category = FunctionCategory.new(:name => existing_function_category.name)
    assert(!function_category.valid?, "Should not save entry unless name is unique")
    assert(function_category.errors.invalid?(:name), "Expected an error for duplicate name")
  end
  
end
