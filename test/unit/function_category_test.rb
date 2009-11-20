require 'test_helper'

class FunctionCategoryTest < ActiveSupport::TestCase
  
  test "should be ok" do
    function_category = FunctionCategory.create(:name => Time.now)
    assert function_category.valid?, function_category.errors.full_messages.join("\n") 
  end
  
  test "should not save function category with no name" do
    function_category = FunctionCategory.new(:name => nil)
    assert(!function_category.valid?, "Should not save entry unless name has been set")
    assert(function_category.errors.invalid?(:name), "Expected an error for missing name")
  end
  
  test "should not save function category with duplicate name" do
    existing_function_category = function_categories(:function_category)
    function_category = FunctionCategory.new(:name => existing_function_category.name)
    assert(!function_category.valid?, "Should not save entry unless name is unique")
    assert(function_category.errors.invalid?(:name), "Expected an error for duplicate name")
  end

  test "should not delete function category with associated function" do
    function_category = FunctionCategory.create(:name => Time.now)
    function = Function.create(:name => Time.now, :function_category => function_category)
    function_category.destroy
    assert(function_category.errors.on_base, "Expected an error for forbidden deletion")
  end

end
