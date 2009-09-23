require 'test_helper'
include ActionController::TestProcess

class SpexareTest < ActiveSupport::TestCase
  fixtures :spexare, :spex, :spex_categories, :functions, :function_categories

  def test_ok
    spexare = Spexare.create(:last_name => Time.now, :first_name => Time.now)
    assert spexare.valid?, spexare.errors.full_messages.join("\n") 
  end

  def test_ok_with_social_security_number
    spexare = Spexare.create(:last_name => Time.now, :first_name => Time.now, :social_security_number => '1234')
    assert spexare.valid?, spexare.errors.full_messages.join("\n") 
  end

  def test_ok_with_jpg_picture
    picture = fixture_file_upload('files/jpgFile.jpg', 'image/jpeg')
    spexare = Spexare.create(:last_name => Time.now, :first_name => Time.now, :picture => picture)
    assert spexare.valid?, spexare.errors.full_messages.join("\n") 
  end
  
  def test_ok_with_gif_picture
    picture = fixture_file_upload('files/gifFile.gif', 'image/gif')
    spexare = Spexare.create(:last_name => Time.now, :first_name => Time.now, :picture => picture)
    assert spexare.valid?, spexare.errors.full_messages.join("\n") 
  end
  
  def test_ok_with_png_picture
    picture = fixture_file_upload('files/pngFile.png', 'image/png')
    spexare = Spexare.create(:last_name => Time.now, :first_name => Time.now, :picture => picture)
    assert spexare.valid?, spexare.errors.full_messages.join("\n") 
  end

  def test_should_not_save_spexare_with_no_last_name
    spexare = Spexare.new(:last_name => nil, :first_name => Time.now)
    assert(!spexare.valid?, "Should not save entry unless last name has been set")
    assert(spexare.errors.invalid?(:last_name), "Expected an error for missing last name")
  end

  def test_should_not_save_spexare_with_no_first_name
    spexare = Spexare.new(:last_name => Time.now, :first_name => nil)
    assert(!spexare.valid?, "Should not save entry unless first name has been set")
    assert(spexare.errors.invalid?(:first_name), "Expected an error for missing first name")
  end

  def test_should_not_save_spexare_with_invalid_social_security_number
    spexare = Spexare.new(:last_name => Time.now, :first_name => Time.now, :social_security_number => 'invalid')
    assert(!spexare.valid?, "Should not save entry unless a valid social security number has been set")
    assert(spexare.errors.invalid?(:social_security_number), "Expected an error for invalid social security number")
  end

  def test_should_not_save_spexare_with_too_large_picture
    picture = fixture_file_upload('files/largeFile.jpg', 'image/jpg')
    spexare = Spexare.create(:last_name => Time.now, :first_name => Time.now, :picture => picture)
    assert(!spexare.valid?, "Should not save entry if an invalid picture has been set")
    assert(spexare.errors.invalid?(:picture), "Expected an error for invalid picture")
  end
  
  def test_should_not_save_spexare_with_invalid_picture
    picture = fixture_file_upload('files/invalidFileType.txt', 'text/plain')
    spexare = Spexare.create(:last_name => Time.now, :first_name => Time.now, :picture => picture)
    assert(!spexare.valid?, "Should not save entry if an invalid picture has been set")
    assert(spexare.errors.invalid?(:picture), "Expected an error for invalid picture")
  end

  def test_should_not_save_spexare_with_invalid_related_spexare
    spexare_1 = spexare(:spexare_1)
    spexare_2 = spexare(:spexare_2)
    begin
      spexare_3 = Spexare.new(:last_name => Time.now, :first_name => Time.now)
      spexare_3.add_related_spexare(spexare_1)
    rescue Exception
      puts $!.to_s
    end
  end

#  def test_related_spexare
#    spexare_item_1 = SpexareItem.new(:last_name => 'TestLastName1', :first_name => 'TestFirstName1')
#    spexare_item_2 = SpexareItem.new(:last_name => 'TestLastName2', :first_name => 'TestFirstName2')
#    spexare_item_1.add_related_spexare(spexare_item_2)
#    assert spexare_item_1.valid?, spexare_item_1.errors.full_messages
#    assert_equal 1, spexare_item_1.related_spexare_items.size
#    assert spexare_item_1.has_related_spexare?
#    spexare_item_3 = SpexareItem.new(:last_name => 'TestLastName3', :first_name => 'TestFirstName3')
#    begin
#      spexare_item_1.add_related_spexare(spexare_item_3)
#    rescue Exception
#      assert_equal 'Det går bara att ha en relation åt gången med en annan spexare.', $!.to_s
#    end
#    assert_equal 1, spexare_item_1.related_spexare_items.size
#    begin
#      spexare_item_3.add_related_spexare(spexare_item_1)
#    rescue Exception
#      assert_equal "Den angivna spexaren i 'Gift/sambo med' har redan en relation (kan endast ha en åt gången).", $!.to_s
#    end
#    spexare_item_1.remove_related_spexare
#    assert_equal 0, spexare_item_1.related_spexare_items.size
#    assert_equal 0, spexare_item_2.related_spexare_items.size
#  end

end
