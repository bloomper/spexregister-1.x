require File.dirname(__FILE__) + '/../test_helper'

class SpexareItemTest < Test::Unit::TestCase
  fixtures :spexare_items, :spex_items, :spex_category_items, :function_items, :function_category_items

  def setup
    FileUtils.rm_f 'index/test/'
    SpexareItem.rebuild_index
  end

  def test_validation_on_create
    spexare_item = SpexareItem.new(:last_name => nil, :first_name => nil)
    assert !spexare_item.valid?, spexare_item.errors.full_messages
    assert spexare_item.errors.invalid?(:last_name), spexare_item.errors.full_messages
    assert_equal "Du måste ange 'Efternamn'.", spexare_item.errors.on(:last_name) 
    spexare_item.last_name = 'TestLastName'
    assert !spexare_item.valid?, spexare_item.errors.full_messages
    assert spexare_item.errors.invalid?(:first_name), spexare_item.errors.full_messages
    assert_equal "Du måste ange 'Förnamn'.", spexare_item.errors.on(:first_name) 
    spexare_item.first_name = 'TestFirstName'
    assert spexare_item.valid?, spexare_item.errors.full_messages
    spexare_item.social_security = 'TestSocialSecurity'
    assert !spexare_item.valid?, spexare_item.errors.full_messages
    assert spexare_item.errors.invalid?(:social_security), spexare_item.errors.full_messages
    assert_equal "'Personnummer' måste innehålla fyra siffror.", spexare_item.errors.on(:social_security) 
    spexare_item.social_security = '1234'
    assert spexare_item.valid?, spexare_item.errors.full_messages
  end

  def test_validation_picture
    spexare_item = SpexareItem.new(:last_name => 'TestLastName', :first_name => 'TestFirstName')
    spexare_item.spexare_picture_item = upload_file :class => SpexarePictureItem, :filename => '/files/rails.png', :content_type => 'image/png'
    assert spexare_item.valid?, spexare_item.errors.full_messages
    spexare_item.spexare_picture_item = upload_file :class => SpexarePictureItem, :filename => '/files/rails.gif', :content_type => 'image/gif'
    assert spexare_item.valid?, spexare_item.errors.full_messages
    spexare_item.spexare_picture_item = upload_file :class => SpexarePictureItem, :filename => '/files/rails.jpg', :content_type => 'image/jpeg'
    assert spexare_item.valid?, spexare_item.errors.full_messages
    spexare_item.spexare_picture_item = upload_file :class => SpexarePictureItem, :filename => '/files/foo.txt', :content_type => 'text/plain'
    assert !spexare_item.valid?, spexare_item.errors.full_messages
    assert_equal "'Bild' får endast vara av typerna PNG, JPG och GIF.", spexare_item.errors.on(:spexare_picture_item) 
    spexare_item.spexare_picture_item = upload_file :class => SpexarePictureItem, :filename => '/files/large_file.jpg', :content_type => 'image/jpeg'
    assert !spexare_item.valid?, spexare_item.errors.full_messages
    assert_equal "Storleken på 'Bild' får inte överskrida 150 Kb.", spexare_item.errors.on(:spexare_picture_item) 
  end

  def test_related_spexare
    spexare_item_1 = SpexareItem.new(:last_name => 'TestLastName1', :first_name => 'TestFirstName1')
    spexare_item_2 = SpexareItem.new(:last_name => 'TestLastName2', :first_name => 'TestFirstName2')
    spexare_item_1.add_related_spexare(spexare_item_2)
    assert spexare_item_1.valid?, spexare_item_1.errors.full_messages
    assert_equal 1, spexare_item_1.related_spexare_items.size
    assert spexare_item_1.has_related_spexare?
    spexare_item_3 = SpexareItem.new(:last_name => 'TestLastName3', :first_name => 'TestFirstName3')
    begin
      spexare_item_1.add_related_spexare(spexare_item_3)
    rescue Exception
      assert_equal 'Det går bara att ha en relation åt gången med en annan spexare.', $!.to_s
    end
    assert_equal 1, spexare_item_1.related_spexare_items.size
    begin
      spexare_item_3.add_related_spexare(spexare_item_1)
    rescue Exception
      assert_equal "Den angivna spexaren i 'Gift/sambo med' har redan en relation (kan endast ha en åt gången).", $!.to_s
    end
    spexare_item_1.remove_related_spexare
    assert_equal 0, spexare_item_1.related_spexare_items.size
    assert_equal 0, spexare_item_2.related_spexare_items.size
  end

  def test_full_name
    spexare_item = SpexareItem.new(:last_name => 'TestLastName', :first_name => 'TestFirstName')
    assert_equal 'TestFirstName TestLastName', spexare_item.full_name
    spexare_item.nick_name = 'TestNickName'
    assert_equal "TestFirstName 'TestNickName' TestLastName", spexare_item.full_name
  end
  
  def test_find_by_full_name
    spexare_items = SpexareItem.find_by_full_name('FirstName LastName', 2)
    assert_equal 2, spexare_items.size
    spexare_items = SpexareItem.find_by_full_name('FirstName', 2)
    assert_equal 2, spexare_items.size
    spexare_items = SpexareItem.find_by_full_name('FirstName LastName', 2, 1)
    assert_equal 1, spexare_items.size
    spexare_items = SpexareItem.find_by_full_name('FirstName', 2, 1)
    assert_equal 1, spexare_items.size
  end

  def test_indexing
    assert SpexareItem.find_by_contents('"dummy"').empty?
    spexare_item = SpexareItem.new(:last_name => 'TestLastName', :first_name => 'TestFirstName')
    assert spexare_item.ferret_enabled?, 'Ferret is not enabled'
    spexare_item.save
    assert_equal spexare_item, SpexareItem.find_by_contents('"TestLastName"').first
    spex_item_1 = spex_items(:test_spex_1)
    spex_item_2 = spex_items(:test_spex_2)
    function_item = function_items(:test_function_1)
    actor_item = ActorItem.new(:role => 'TestRole', :vocal => ActorItem::VOCAL_TYPES[0])
    link_item_1 = LinkItem.new(:actor_item => actor_item, :spex_item => spex_item_1)
    link_item_1.function_items << function_item
    spexare_item.link_items << link_item_1
    link_item_2 = LinkItem.new(:actor_item => actor_item, :spex_item => spex_item_2)
    link_item_2.function_items << function_item
    spexare_item.link_items << link_item_2
    spexare_item.save
    assert_equal spexare_item, SpexareItem.find_by_contents('"TestLastName"').first
    assert_equal spexare_item, SpexareItem.find_by_contents('förnamn:"TestFirstName"').first
    assert_equal spexare_item, SpexareItem.find_by_contents('spexår:"1098"').first
    assert_equal spexare_item, SpexareItem.find_by_contents('funktionsnamn:"Test Function"').first
    assert_equal 0, SpexareItem.find_by_contents('spexår:1097').size
    spexare_item.link_items.delete(link_item_2)
    spexare_item.save
    assert_equal spexare_item, SpexareItem.find_by_contents('spexår:1098').first
    assert_equal 0, SpexareItem.find_by_contents('spexår:1099').size
  end

  private
    def upload_file(options = {})
      att = options[:class].create :uploaded_data => fixture_file_upload(options[:filename], options[:content_type] || 'image/png')
      att.reload unless att.new_record?
      att
    end
end
