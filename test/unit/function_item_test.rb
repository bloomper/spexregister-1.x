require File.dirname(__FILE__) + '/../test_helper'

class FunctionItemTest < Test::Unit::TestCase
  fixtures :function_items, :function_category_items

  def test_validation_on_create
    function_category_item = function_category_items(:test_category_1)
    function_item = FunctionItem.new(:name => nil, :function_category_item => nil)
    assert !function_item.valid?, function_item.errors.full_messages
    assert function_item.errors.invalid?(:name), function_item.errors.full_messages
    assert_equal "Du måste ange 'Namn'.", function_item.errors.on(:name) 
    assert function_item.errors.invalid?(:function_category_item), function_item.errors.full_messages
    assert_equal "Du måste ange 'Kategori'.", function_item.errors.on(:function_category_item) 
    function_item.name = 'TestName'
    assert !function_item.valid?, function_item.errors.full_messages
    function_item.function_category_item = function_category_item
    assert function_item.valid?, function_item.errors.full_messages
    function_item.save
    another_function_item = FunctionItem.new(:name => 'TestName', :function_category_item => function_category_item)
    assert !another_function_item.valid?, another_function_item.errors.full_messages
    assert_equal 'Kombinationen av namn och kategori används redan.', another_function_item.errors.on_base 
    another_function_item.name = 'TestName2'
    assert another_function_item.valid?, another_function_item.errors.full_messages
  end

  def test_validation_on_update
    function_category_item_1 = function_category_items(:test_category_1)
    function_category_item_2 = function_category_items(:test_category_2)
    function_item = FunctionItem.new(:name => 'TestName1', :function_category_item => function_category_item_1)
    function_item.save
    another_function_item = FunctionItem.new(:name => 'TestName2', :function_category_item => function_category_item_2)
    another_function_item.save
    another_function_item.name = 'TestName1'
    assert another_function_item.valid?, another_function_item.errors.full_messages
    another_function_item.function_category_item = function_category_item_1
    assert !another_function_item.valid?, another_function_item.errors.full_messages
    assert_equal 'Kombinationen av namn och kategori används redan.', another_function_item.errors.on_base 
  end

  def test_name_with_category
    function_category_item = function_category_items(:test_category_1)
    function_item = FunctionItem.new(:name => 'Test', :function_category_item => function_category_item)
    assert_equal "Test (#{function_category_item.category_name})", function_item.name_with_category
  end
end
