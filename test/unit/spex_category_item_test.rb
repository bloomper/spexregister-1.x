require File.dirname(__FILE__) + '/../test_helper'

class SpexCategoryItemTest < Test::Unit::TestCase
  fixtures :spex_category_items

  def test_validation_on_create
    spex_category_item = SpexCategoryItem.new(:category_name => nil)
    assert !spex_category_item.valid?, spex_category_item.errors.full_messages
    assert spex_category_item.errors.invalid?(:category_name), spex_category_item.errors.full_messages
    assert_equal "Du måste ange 'Kategorinamn'.", spex_category_item.errors.on(:category_name) 
    spex_category_item.category_name = 'TestCategory'
    assert spex_category_item.valid?, spex_category_item.errors.full_messages
    spex_category_item.save

    another_spex_category_item = SpexCategoryItem.new(:category_name => 'TestCategory')
    assert !another_spex_category_item.valid?, another_spex_category_item.errors.full_messages
    assert another_spex_category_item.errors.invalid?(:category_name), another_spex_category_item.errors.full_messages
    assert_equal "Angivet 'Kategorinamn' existerar redan.", another_spex_category_item.errors.on(:category_name) 
    another_spex_category_item.category_name = 'TestCategory2'
    assert another_spex_category_item.valid?, another_spex_category_item.errors.full_messages
  end
end
