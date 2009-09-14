require "#{File.dirname(__FILE__)}/../test_helper"

class SearchExportStoriesTest < ActionController::IntegrationTest
  fixtures :role_items, :user_items, :spexare_items, :spex_items, :spex_category_items, :function_items, :function_category_items, :configuration_items

  def test_signup
    new_session do |user|
      user.goes_to_login
      user.signup :new_account_email_address => 'testemailaddress@test.se', :new_account_name=> 'TestName', :new_account_user_name => 'TestUserName', :new_account_description => 'TestDescription'
    end
  end
  
  def test_simple_search_and_export
    new_session do |user|
      user.goes_to_login
      user.logs_in :user_name => user_items(:test_user).user_name, :user_password => 'TestUserPassword'
      user.goes_to_simple_search
      user.performs_simple_search :spex_category_item => {:id => '-1'}, :function_category_item => {:id => '-1'}
      user.initiates_export :source => 'simple_search', :type => 'pdf'
      user.performs_export :template => 'labels3x8', :source => 'simple_search', :type => 'pdf'
      user.logs_out
    end
  end

  def test_advanced_search_and_export
    new_session do |user|
      user.goes_to_login
      user.logs_in :user_name => user_items(:test_user).user_name, :user_password => 'TestUserPassword'
      user.goes_to_advanced_search
      user.performs_advanced_search :query => "*"
      user.initiates_export :source => 'advanced_search', :type => 'pdf'
      user.performs_export :template => 'labels3x8', :source => 'advanced_search', :type => 'pdf'
      user.logs_out
    end
  end

  private
    module TestingDSL
      def signup(options)
        xml_http_request '/home/login', options
        assert_response :success
        assert_template 'home/login'
      end
      
      def goes_to_simple_search
        get '/search/simple_search'
        assert_response :success
        assert_template 'search/simple_search'
      end

      def performs_simple_search(options)
        post '/search/simple_search', options
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_template 'search/simple_search_result'
      end

      def goes_to_advanced_search
        get '/search/advanced_search'
        assert_response :success
        assert_template 'search/advanced_search'
      end

      def performs_advanced_search(options)
        post '/search/advanced_search', options
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_template 'search/advanced_search_result'
      end
      
      def initiates_export(options)
        get '/export/initiate_export', options
        assert_response :success
        assert_template 'export/initiate_export'
      end

      def performs_export(options)
        get '/export/perform_export', options
        assert_response :success
        assert_template "export/#{options[:template]}"
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
    
    def new_session
      open_session do |session|
        session.extend(TestingDSL)
        yield session if block_given?
      end
    end    
end
