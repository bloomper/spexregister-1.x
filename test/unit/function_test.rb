require 'test_helper'

class FunctionTest < ActiveSupport::TestCase
  
  test "should be ok" do
    function = Function.create(:name => Time.now, :function_category => function_categories(:function_category))
    assert function.valid?, function.errors.full_messages.join("\n") 
  end
  
  test "should not save function with no name" do
    function = Function.new(:name => nil, :function_category => function_categories(:function_category))
    assert(!function.valid?, "Should not save entry unless name has been set")
    assert(function.errors.invalid?(:name), "Expected an error for missing name")
  end
  
  test "should not save function with no function category" do
    function = Function.new(:name => Time.now, :function_category => nil)
    assert(!function.valid?, "Should not save entry unless function category has been set")
    assert(function.errors.invalid?(:function_category), "Expected an error for missing function category")
  end
  
  test "should not save function with invalid combination" do
    existing_function = functions(:function)
    function = Function.new(:name => existing_function.name, :function_category => existing_function.function_category)
    assert(!function.valid?, "Should not save entry if an invalid combination has been set")
    assert(function.errors.on_base, "Expected an error for invalid combination")
  end
  
  test "should not update spex with invalid combination" do
    existing_function = functions(:function)
    function = Function.create(:name => Time.now, :function_category => function_categories(:function_category))
    assert function.valid?, function.errors.full_messages.join("\n") 
    function.name = existing_function.name
    function.function_category = existing_function.function_category
    function.save
    assert(!function.valid?, "Should not update entry if an invalid combination has been set")
    assert(function.errors.on_base, "Expected an error for invalid combination")
  end

  test "should not delete function with associated spexare" do
    spexare = Spexare.create(:last_name => Time.now, :first_name => Time.now)
    activity = Activity.create(:spexare => spexare)
    function = Function.create(:name => Time.now, :function_category => function_categories(:function_category))
    function_activity = FunctionActivity.create(:activity => activity, :function => function)
    function.destroy
    assert(function.errors.on_base, "Expected an error for forbidden deletion")
  end
  
  test "name with category" do
    existing_function = functions(:function)
    assert_equal "#{existing_function.name} (#{existing_function.function_category.name})", existing_function.name_with_category
  end
end
