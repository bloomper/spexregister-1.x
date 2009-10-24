require 'test_helper'

class NewsTest < ActiveSupport::TestCase
  
  test "should be ok" do
    news = News.create(:publication_date => Time.now, :subject => Time.now, :body => Time.now)
    assert news.valid?, news.errors.full_messages.join("\n") 
  end
  
  test "should not save news with no publication date" do
    news = News.new(:publication_date => nil, :subject => Time.now, :body => Time.now)
    assert(!news.valid?, "Should not save entry unless publication date has been set")
    assert(news.errors.invalid?(:publication_date), "Expected an error for missing publication date")
  end
  
  test "should not save news with no subject" do
    news = News.new(:publication_date => Time.now, :subject => nil, :body => Time.now)
    assert(!news.valid?, "Should not save entry unless subject has been set")
    assert(news.errors.invalid?(:subject), "Expected an error for missing subject")
  end
  
  test "should not save news with no body" do
    news = News.new(:publication_date => Time.now, :subject => Time.now, :body => nil)
    assert(!news.valid?, "Should not save entry unless body has been set")
    assert(news.errors.invalid?(:body), "Expected an error for missing body")
  end

  test "should not save news with invalid publication date" do
    news = News.new(:publication_date => 'invaliddate', :subject => Time.now, :body => Time.now)
    assert(!news.valid?, "Should not save entry unless publication date has been set")
    assert(news.errors.invalid?(:publication_date), "Expected an error for invalid publication date")
  end

end
