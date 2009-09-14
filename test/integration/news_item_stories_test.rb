require "#{File.dirname(__FILE__)}/../test_helper"

class NewsItemStoriesTest < ActionController::IntegrationTest
  fixtures :role_items, :user_items, :configuration_items

  def get_news_item
    {
      :publication_date => '2099-01-01',
      :subject => 'TestSubject',
      :body => 'TestBody'
    }
  end
  
  def get_updated_news_item
    {
      :publication_date => '2099-02-01',
      :subject => 'TestSubjectUpdated',
      :body => 'TestBodyUpdated'
    }
  end
  
  def test_manage_news_item
    new_session do |admin_user|
      admin_user.goes_to_login
      admin_user.logs_in :user_name => user_items(:test_admin_user).user_name, :user_password => 'TestUserPassword'
      admin_user.instantiates_new_news_item
      admin_user.creates_new_news_item :news_item => get_news_item
      id = check_for_news_item get_news_item
      admin_user.lists_news_items
      admin_user.shows_news_item :id => id
      admin_user.lists_news_items
      admin_user.edits_news_item :id => id
      admin_user.updates_news_item :id => id, :news_item => get_updated_news_item 
      check_for_news_item get_updated_news_item
      admin_user.lists_news_items
      admin_user.destroys_news_item :id => id
      admin_user.logs_out
    end
  end
  
  private
    module TestingDSL
      def instantiates_new_news_item
        get '/admin/news_item/new'
        assert_response :success
        assert_template 'admin/news_item/new'
      end

      def creates_new_news_item(options)
        post '/admin/news_item/create', options
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_template 'home/index'
      end

      def lists_news_items
        get '/admin/news_item/list'
        assert_response :success
        assert_template 'admin/news_item/list'
      end

      def shows_news_item(options)
        get '/admin/news_item/show', options
        assert_response :success
        assert_template 'admin/news_item/show'
      end

      def edits_news_item(options)
        get '/admin/news_item/edit', options
        assert_response :success
        assert_template 'admin/news_item/edit'
      end

      def updates_news_item(options)
        post '/admin/news_item/update', options
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_template 'home/index'
      end

      def destroys_news_item(options)
        post '/admin/news_item/destroy', options
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_template 'home/index'
      end

      def goes_to_login
        get '/home/login'
        assert_response :success
        assert_template 'home/login'
      end

      def logs_in(options)
        post '/home/login', options
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_template 'home/index'
      end
      
      def logs_out
        get '/home/logout'
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_template 'home/login'
      end
    end
    
    def check_for_news_item(expected_news_item)
      news_item = NewsItem.find_by_publication_date(expected_news_item[:publication_date])
      assert_not_nil news_item
      
      assert_equal expected_news_item[:publication_date], news_item.publication_date
      assert_equal expected_news_item[:subject], news_item.subject
      assert_equal expected_news_item[:body], news_item.body
      
      return news_item.id
    end
    
    def new_session
      open_session do |session|
        session.extend(TestingDSL)
        yield session if block_given?
      end
    end    
end
