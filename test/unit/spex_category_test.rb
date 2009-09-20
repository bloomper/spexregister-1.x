require 'test_helper'

class SpexCategoryTest < ActiveSupport::TestCase
  fixtures :spex_categories

  def test_ok
    spex_category = SpexCategory.create(:name => Time.now)
    assert spex_category.valid?, spex_category.errors.full_messages.join("\n") 
  end
  
  def test_should_not_save_spex_category_with_no_name
    spex_category = SpexCategory.new(:name => nil)
    assert(!spex_category.valid?, "Should not save entry unless name has been set")
    assert(spex_category.errors.invalid?(:name), "Expected an error for missing name")
  end
  
  def test_should_not_save_spex_category_with_duplicate_name
    existing_spex_category = spex_categories(:spex_category)
    spex_category = SpexCategory.new(:name => existing_spex_category.name)
    assert(!spex_category.valid?, "Should not save entry unless name is unique")
    assert(spex_category.errors.invalid?(:name), "Expected an error for duplicate name")
  end

end
