require 'test_helper'

class SpexCategoryTest < ActiveSupport::TestCase
  include ActionController::TestProcess

  test "should be ok" do
    spex_category = SpexCategory.create(:name => Time.now)
    assert spex_category.valid?, spex_category.errors.full_messages.join("\n") 
  end

  test "should be ok with jpg logo" do
    logo = fixture_file_upload('files/jpgFile.jpg', 'image/jpeg', :binary)
    spex_category = SpexCategory.create(:name => Time.now, :logo => logo)
    assert spex_category.valid?, spex_category.errors.full_messages.join("\n") 
  end
  
  test "should be ok with gif logo" do
    logo = fixture_file_upload('files/gifFile.gif', 'image/gif', :binary)
    spex_category = SpexCategory.create(:name => Time.now, :logo => logo)
    assert spex_category.valid?, spex_category.errors.full_messages.join("\n") 
  end
  
  test "should be ok with png logo" do
    logo = fixture_file_upload('files/pngFile.png', 'image/png', :binary)
    spex_category = SpexCategory.create(:name => Time.now, :logo => logo)
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

  test "should not save spex category with too large logo" do
    logo = fixture_file_upload('files/largeFile.jpg', 'image/jpg', :binary)
    spex_category = SpexCategory.new(:name => Time.now, :logo => logo)
    assert(!spex_category.valid?, "Should not save entry if an invalid logo has been set")
    assert(spex_category.errors.invalid?(:logo), "Expected an error for invalid logo")
  end
  
  test "should not save spex category with invalid logo" do
    logo = fixture_file_upload('files/invalidFileType.txt', 'text/plain', :binary)
    spex_category = SpexCategory.new(:name => Time.now, :logo => logo)
    assert(!spex_category.valid?, "Should not save entry if an invalid logo has been set")
    assert(spex_category.errors.invalid?(:logo), "Expected an error for invalid logo")
  end

end
