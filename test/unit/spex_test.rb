require 'test_helper'
include ActionController::TestProcess

class SpexTest < ActiveSupport::TestCase
  fixtures :spex, :spex_categories
  
  def test_ok
    spex = Spex.create(:year => '2099', :title => Time.now, :spex_category => spex_categories(:spex_category))
    assert spex.valid?, spex.errors.full_messages.join("\n") 
  end
  
  def test_ok_with_jpg_poster
    poster = fixture_file_upload('files/jpgFile.jpg', 'image/jpeg')
    spex = Spex.create(:year => '2099', :title => Time.now, :spex_category => spex_categories(:spex_category), :poster => poster)
    assert spex.valid?, spex.errors.full_messages.join("\n") 
  end
  
  def test_ok_with_gif_poster
    poster = fixture_file_upload('files/gifFile.gif', 'image/gif')
    spex = Spex.create(:year => '2099', :title => Time.now, :spex_category => spex_categories(:spex_category), :poster => poster)
    assert spex.valid?, spex.errors.full_messages.join("\n") 
  end
  
  def test_ok_with_png_poster
    poster = fixture_file_upload('files/pngFile.png', 'image/png')
    spex = Spex.create(:year => '2099', :title => Time.now, :spex_category => spex_categories(:spex_category), :poster => poster)
    assert spex.valid?, spex.errors.full_messages.join("\n") 
  end
  
  def test_should_not_save_spex_with_no_year
    spex = Spex.new(:year => nil, :title => Time.now, :spex_category => spex_categories(:spex_category))
    assert(!spex.valid?, "Should not save entry unless year has been set")
    assert(spex.errors.invalid?(:year), "Expected an error for missing year")
  end
  
  def test_should_not_save_spex_with_no_title
    spex = Spex.new(:year => '2099', :title => nil, :spex_category => spex_categories(:spex_category))
    assert(!spex.valid?, "Should not save entry unless title has been set")
    assert(spex.errors.invalid?(:title), "Expected an error for missing title")
  end
  
  def test_should_not_save_spex_with_no_spex_category
    spex = Spex.new(:year => '2099', :title => Time.now, :spex_category => nil)
    assert(!spex.valid?, "Should not save entry unless spex category has been set")
    assert(spex.errors.invalid?(:spex_category), "Expected an error for missing spex category")
  end
  
  def test_should_not_save_spex_with_invalid_year
    spex = Spex.new(:year => 'invalidyear', :title => Time.now, :spex_category => spex_categories(:spex_category))
    assert(!spex.valid?, "Should not save entry unless a valid year has been set")
    assert(spex.errors.invalid?(:year), "Expected an error for invalid year")
  end
  
  def test_should_not_save_spex_with_too_large_poster
    poster = fixture_file_upload('files/largeFile.jpg', 'image/jpg')
    spex = Spex.new(:year => '2099', :title => Time.now, :spex_category => spex_categories(:spex_category), :poster => poster)
    assert(!spex.valid?, "Should not save entry if an invalid poster has been set")
    assert(spex.errors.invalid?(:poster), "Expected an error for invalid poster")
  end
  
  def test_should_not_save_spex_with_invalid_poster
    poster = fixture_file_upload('files/invalidFileType.txt', 'text/plain')
    spex = Spex.new(:year => '2099', :title => Time.now, :spex_category => spex_categories(:spex_category), :poster => poster)
    assert(!spex.valid?, "Should not save entry if an invalid poster has been set")
    assert(spex.errors.invalid?(:poster), "Expected an error for invalid poster")
  end
  
  def test_should_not_save_spex_with_invalid_combination
    existing_spex = spex(:spex_1)
    spex = Spex.new(:year => existing_spex.year, :title => existing_spex.title, :spex_category => existing_spex.spex_category)
    assert(!spex.valid?, "Should not save entry if an invalid combination has been set")
    assert(spex.errors.on_base, "Expected an error for invalid combination")
  end

  def test_should_not_save_spex_with_already_existing_combination
    existing_spex = spex(:spex_1)
    spex = Spex.new(:year => '2099', :title => existing_spex.title, :spex_category => existing_spex.spex_category)
    assert(!spex.valid?, "Should not save entry if an already existing combination has been set")
    assert(spex.errors.on_base, "Expected an error for already existing combination")
  end

  def test_should_not_update_spex_with_invalid_combination
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

  def test_should_not_update_spex_with_already_existing_combination
    existing_spex = spex(:spex_1)
    spex = Spex.create(:year => '2099', :title => Time.now, :spex_category => spex_categories(:spex_category))
    assert spex.valid?, spex.errors.full_messages.join("\n") 
    spex.title = existing_spex.title
    spex.spex_category = existing_spex.spex_category
    spex.save
    assert(!spex.valid?, "Should not update entry if an already existing combination has been set")
    assert(spex.errors.on_base, "Expected an error for already existing combination")
  end

end
