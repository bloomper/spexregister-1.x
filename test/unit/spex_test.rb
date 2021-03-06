require 'test_helper'

class SpexTest < ActiveSupport::TestCase
  include ActionController::TestProcess
  
  test "should be ok" do
    spex = Spex.create(:year => '2099', :title => Time.now, :spex_category => spex_categories(:spex_category))
    assert spex.valid?, spex.errors.full_messages.join("\n") 
  end
  
  test "should be ok with jpg poster" do
    poster = fixture_file_upload('files/jpgFile.jpg', 'image/jpeg', :binary)
    spex = Spex.create(:year => '2099', :title => Time.now, :spex_category => spex_categories(:spex_category), :poster => poster)
    assert spex.valid?, spex.errors.full_messages.join("\n") 
  end
  
  test "should be ok with gif poster" do
    poster = fixture_file_upload('files/gifFile.gif', 'image/gif', :binary)
    spex = Spex.create(:year => '2099', :title => Time.now, :spex_category => spex_categories(:spex_category), :poster => poster)
    assert spex.valid?, spex.errors.full_messages.join("\n") 
  end
  
  test "should be ok with png poster" do
    poster = fixture_file_upload('files/pngFile.png', 'image/png', :binary)
    spex = Spex.create(:year => '2099', :title => Time.now, :spex_category => spex_categories(:spex_category), :poster => poster)
    assert spex.valid?, spex.errors.full_messages.join("\n") 
  end
  
  test "should not save spex with no year" do
    spex = Spex.new(:year => nil, :title => Time.now, :spex_category => spex_categories(:spex_category))
    assert(!spex.valid?, "Should not save entry unless year has been set")
    assert(spex.errors.invalid?(:year), "Expected an error for missing year")
  end
  
  test "should not save spex with no title" do
    spex = Spex.new(:year => '2099', :title => nil, :spex_category => spex_categories(:spex_category))
    assert(!spex.valid?, "Should not save entry unless title has been set")
    assert(spex.errors.invalid?(:title), "Expected an error for missing title")
  end
  
  test "should not save spex with no spex category" do
    spex = Spex.new(:year => '2099', :title => Time.now, :spex_category => nil)
    assert(!spex.valid?, "Should not save entry unless spex category has been set")
    assert(spex.errors.invalid?(:spex_category), "Expected an error for missing spex category")
  end
  
  test "should not save spex with invalid year" do
    spex = Spex.new(:year => 'invalidyear', :title => Time.now, :spex_category => spex_categories(:spex_category))
    assert(!spex.valid?, "Should not save entry unless a valid year has been set")
    assert(spex.errors.invalid?(:year), "Expected an error for invalid year")
  end
  
  test "should not save spex with too large poster" do
    poster = fixture_file_upload('files/largeFile.jpg', 'image/jpg', :binary)
    spex = Spex.new(:year => '2099', :title => Time.now, :spex_category => spex_categories(:spex_category), :poster => poster)
    assert(!spex.valid?, "Should not save entry if an invalid poster has been set")
    assert(spex.errors.invalid?(:poster), "Expected an error for invalid poster")
  end
  
  test "should not save spex with invalid poster" do
    poster = fixture_file_upload('files/invalidFileType.txt', 'text/plain', :binary)
    spex = Spex.new(:year => '2099', :title => Time.now, :spex_category => spex_categories(:spex_category), :poster => poster)
    assert(!spex.valid?, "Should not save entry if an invalid poster has been set")
    assert(spex.errors.invalid?(:poster), "Expected an error for invalid poster")
  end
  
  test "should not save spex with invalid combination" do
    existing_spex = spex(:spex_1)
    spex = Spex.new(:year => existing_spex.year, :title => existing_spex.title, :spex_category => existing_spex.spex_category)
    assert(!spex.valid?, "Should not save entry if an invalid combination has been set")
    assert(spex.errors.on_base, "Expected an error for invalid combination")
  end

  test "should not update spex with invalid combination" do
    existing_spex = spex(:spex_1)
    spex = Spex.create(:year => '2099', :title => Time.now, :spex_category => spex_categories(:spex_category))
    assert spex.valid?, spex.errors.full_messages.join("\n") 
    spex.year = existing_spex.year
    spex.title = existing_spex.title
    spex.spex_category = existing_spex.spex_category
    spex.save
    assert(!spex.valid?, "Should not update entry if an invalid combination has been set")
    assert(spex.errors.on_base, "Expected an error for invalid combination")
  end

  test "should not delete spex with associated spexare" do
    spexare = Spexare.create(:last_name => Time.now, :first_name => Time.now)
    activity = Activity.create(:spexare => spexare)
    spex = Spex.create(:year => '2099', :title => Time.now, :spex_category => spex_categories(:spex_category))
    spex_activity = SpexActivity.create(:activity => activity, :spex => spex)
    spex.destroy
    assert(spex.errors.on_base, "Expected an error for forbidden deletion")
  end

  test "should be ok with multiple revivals" do
    title = Time.now
    spex = Spex.create(:year => '2099', :title => title, :spex_category => spex_categories(:spex_category))
    assert spex.valid?, spex.errors.full_messages.join("\n") 
    spex = Spex.create(:year => '2100', :title => title, :spex_category => spex_categories(:spex_category), :is_revival => true)
    assert spex.valid?, spex.errors.full_messages.join("\n") 
    spex = Spex.create(:year => '2101', :title => title, :spex_category => spex_categories(:spex_category), :is_revival => true)
    assert spex.valid?, spex.errors.full_messages.join("\n") 
  end

end
