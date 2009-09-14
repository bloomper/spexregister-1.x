require File.dirname(__FILE__) + '/../test_helper'

class NewsItemTest < Test::Unit::TestCase
  fixtures :news_items

  def test_validation_on_create
    news_item = NewsItem.new(:publication_date => nil, :subject => nil, :body => nil)
    assert !news_item.valid?, news_item.errors.full_messages
    assert news_item.errors.invalid?(:publication_date), news_item.errors.full_messages 
    assert_equal "Du måste ange 'Publiceringsdatum'.", news_item.errors.on(:publication_date) 
    assert news_item.errors.invalid?(:subject), news_item.errors.full_messages 
    assert_equal "Du måste ange 'Ämne'.", news_item.errors.on(:subject) 
    assert news_item.errors.invalid?(:body), news_item.errors.full_messages 
    assert_equal "Du måste ange 'Text'.", news_item.errors.on(:body) 
    news_item.publication_date = Date.today()
    assert !news_item.valid?, news_item.errors.full_messages
    news_item.subject = 'TestSubject'
    assert !news_item.valid?, news_item.errors.full_messages
    news_item.body = 'TestBody'
    assert news_item.valid?, news_item.errors.full_messages
  end
end
