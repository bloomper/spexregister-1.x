require File.dirname(__FILE__) + '/../test_helper'

class FunctionCategoryItemTest < Test::Unit::TestCase
  fixtures :function_category_items

  def test_validation_on_create
    function_category_item = FunctionCategoryItem.new(:category_name => nil)
    assert !function_category_item.valid?, function_category_item.errors.full_messages
    assert function_category_item.errors.invalid?(:category_name), function_category_item.errors.full_messages
    assert_equal "Du måste ange 'Kategorinamn'.", function_category_item.errors.on(:category_name) 
    function_category_item.category_name = 'TestCategory'
    assert function_category_item.valid?, function_category_item.errors.full_messages
    function_category_item.save

    another_function_category_item = FunctionCategoryItem.new(:category_name => 'TestCategory')
    assert !another_function_category_item.valid?, another_function_category_item.errors.full_messages
    assert another_function_category_item.errors.invalid?(:category_name), another_function_category_item.errors.full_messages
    assert_equal "Angivet 'Kategorinamn' existerar redan.", another_function_category_item.errors.on(:category_name) 
    another_function_category_item.category_name = 'TestCategory2'
    assert another_function_category_item.valid?, another_function_category_item.errors.full_messages
  end
end
