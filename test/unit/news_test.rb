require 'test_helper'

class NewsTest < ActiveSupport::TestCase
  fixtures :news
  
  def test_ok
    news = News.create(:publication_date => Time.now, :subject => Time.now, :body => Time.now)
    assert news.valid?, news.errors.full_messages.join("\n") 
  end
  
  def test_should_not_save_news_with_no_publication_date
    news = News.new(:publication_date => nil, :subject => Time.now, :body => Time.now)
    assert(!news.valid?, "Should not save entry unless publication date has been set")
    assert(news.errors.invalid?(:publication_date), "Expected an error for missing publication date")
  end
  
  def test_should_not_save_news_with_no_subject
    news = News.new(:publication_date => Time.now, :subject => nil, :body => Time.now)
    assert(!news.valid?, "Should not save entry unless subject has been set")
    assert(news.errors.invalid?(:subject), "Expected an error for missing subject")
  end
  
  def test_should_not_save_news_with_no_body
    news = News.new(:publication_date => Time.now, :subject => Time.now, :body => nil)
    assert(!news.valid?, "Should not save entry unless body has been set")
    assert(news.errors.invalid?(:body), "Expected an error for missing body")
  end
  
end
