require File.dirname(__FILE__) + '/../test_helper'

class SpexItemTest < Test::Unit::TestCase
  fixtures :spex_items, :spex_category_items

  def test_validation_on_create
    spex_category_item = spex_category_items(:test_category_1)
    spex_item = SpexItem.new(:year => nil, :title => nil, :spex_category_item => nil)
    assert !spex_item.valid?, spex_item.errors.full_messages
    assert spex_item.errors.invalid?(:year), spex_item.errors.full_messages
    # We get two errors on :year at this point
    assert spex_item.errors.on(:year).include?("Du måste ange 'År'.") 
    spex_item.year = '2099'
    assert !spex_item.valid?, spex_item.errors.full_messages
    assert spex_item.errors.invalid?(:title), spex_item.errors.full_messages
    assert_equal "Du måste ange 'Titel'.", spex_item.errors.on(:title) 
    spex_item.title = 'TestTitle'
    assert !spex_item.valid?, spex_item.errors.full_messages
    assert spex_item.errors.invalid?(:spex_category_item), spex_item.errors.full_messages
    assert_equal "Du måste ange 'Kategori'.", spex_item.errors.on(:spex_category_item) 
    spex_item.spex_category_item = spex_category_item
    assert spex_item.valid?, spex_item.errors.full_messages
    spex_item.save
    another_spex_item = SpexItem.new(:year => '2099', :title => 'TestTitle', :spex_category_item => spex_category_item)
    assert !another_spex_item.valid?, another_spex_item.errors.full_messages
    assert_equal 'Kombinationen av år, titel och kategori används redan.', another_spex_item.errors.on_base 
    another_spex_item.year = '2098'
    assert !another_spex_item.valid?, another_spex_item.errors.full_messages
    assert_equal 'Det finns redan ett spex med angivna titeln och kategorin.', another_spex_item.errors.on_base 
    another_spex_item.title = 'TestTitle2'
    assert another_spex_item.valid?, another_spex_item.errors.full_messages
    another_spex_item.year = 'TestYear'
    assert !another_spex_item.valid?, another_spex_item.errors.full_messages
    assert_equal "'År' måste vara ett giltligt årtal.", another_spex_item.errors.on(:year) 
  end
  
  def test_validation_on_update
    spex_category_item_1 = spex_category_items(:test_category_1)
    spex_category_item_2 = spex_category_items(:test_category_2)
    spex_item = SpexItem.new(:year => '2098', :title => 'TestTitle1', :spex_category_item => spex_category_item_1)
    spex_item.save
    another_spex_item = SpexItem.new(:year => '2099', :title => 'TestTitle2', :spex_category_item => spex_category_item_2)
    another_spex_item.save
    another_spex_item.year = '2098'
    assert another_spex_item.valid?, another_spex_item.errors.full_messages
    another_spex_item.title = 'TestTitle1'
    another_spex_item.spex_category_item = spex_category_item_1
    assert !another_spex_item.valid?, another_spex_item.errors.full_messages
    assert_equal 'Kombinationen av år, titel och kategori används redan.', another_spex_item.errors.on_base 
    another_spex_item.year = '2099'
    assert !another_spex_item.valid?, another_spex_item.errors.full_messages
    assert_equal 'Det finns redan ett spex med angivna titeln och kategorin.', another_spex_item.errors.on_base 
  end
  
  def test_validation_poster
    spex_category_item = spex_category_items(:test_category_1)
    spex_item = SpexItem.new(:year => '2099', :title => 'TestTitle', :spex_category_item => spex_category_item)
    spex_item.spex_poster_item = upload_file :class => SpexPosterItem, :filename => '/files/rails.png', :content_type => 'image/png'
    assert spex_item.valid?, spex_item.errors.full_messages
    spex_item.spex_poster_item = upload_file :class => SpexPosterItem, :filename => '/files/rails.gif', :content_type => 'image/gif'
    assert spex_item.valid?, spex_item.errors.full_messages
    spex_item.spex_poster_item = upload_file :class => SpexPosterItem, :filename => '/files/rails.jpg', :content_type => 'image/jpeg'
    assert spex_item.valid?, spex_item.errors.full_messages
    spex_item.spex_poster_item = upload_file :class => SpexPosterItem, :filename => '/files/foo.txt', :content_type => 'text/plain'
    assert !spex_item.valid?, spex_item.errors.full_messages
    assert_equal "'Poster' får endast vara av typerna PNG, JPG och GIF.", spex_item.errors.on(:spex_poster_item) 
    spex_item.spex_poster_item = upload_file :class => SpexPosterItem, :filename => '/files/large_file.jpg', :content_type => 'image/jpeg'
    assert !spex_item.valid?, spex_item.errors.full_messages
    assert_equal "Storleken på 'Poster' får inte överskrida 150 Kb.", spex_item.errors.on(:spex_poster_item) 
  end
  
  private
    def upload_file(options = {})
      att = options[:class].create :uploaded_data => fixture_file_upload(options[:filename], options[:content_type] || 'image/png')
      att.reload unless att.new_record?
      att
    end
end
