require 'test_helper'

class SpexCategoryTest < ActiveSupport::TestCase

  test "should be ok" do
    spex_category = SpexCategory.create(:name => Time.now)
    assert spex_category.valid?, spex_category.errors.full_messages.join("\n") 
  end
  
  test "should not save spex category with no name" do
    spex_category = SpexCategory.new(:name => nil)
    assert(!spex_category.valid?, "Should not save entry unless name has been set")
    assert(spex_category.errors.invalid?(:name), "Expected an error for missing name")
  end
  
  test "should not save spex category with duplicate name" do
    existing_spex_category = spex_categories(:spex_category)
    spex_category = SpexCategory.new(:name => existing_spex_category.name)
    assert(!spex_category.valid?, "Should not save entry unless name is unique")
    assert(spex_category.errors.invalid?(:name), "Expected an error for duplicate name")
  end

end
