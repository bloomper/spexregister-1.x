require "#{File.dirname(__FILE__)}/../test_helper"

class FunctionItemStoriesTest < ActionController::IntegrationTest
  fixtures :role_items, :user_items, :function_category_items, :configuration_items

  def get_function_item
    {
      :name => 'Name',
      :function_category_item_id => function_category_items(:test_category_1).id
    }
  end
  
  def get_updated_function_item
    {
      :name => 'NameUpdated',
      :function_category_item_id => function_category_items(:test_category_2).id
    }
  end
  
  def test_manage_function_item
    new_session do |admin_user|
      admin_user.goes_to_login
      admin_user.logs_in :user_name => user_items(:test_admin_user).user_name, :user_password => 'TestUserPassword'
      admin_user.instantiates_new_function_item
      admin_user.creates_new_function_item :function_item => get_function_item
      id = check_for_function_item get_function_item
      admin_user.lists_function_items
      admin_user.shows_function_item :id => id
      admin_user.lists_function_items
      admin_user.edits_function_item :id => id
      admin_user.updates_function_item :id => id, :function_item => get_updated_function_item 
      check_for_function_item get_updated_function_item
      admin_user.lists_function_items
      admin_user.destroys_function_item :id => id
      admin_user.logs_out
    end
  end
  
  private
    module TestingDSL
      def instantiates_new_function_item
        get '/admin/function_item/new'
        assert_response :success
        assert_template 'admin/function_item/new'
      end

      def creates_new_function_item(options)
        post '/admin/function_item/create', options
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_template 'home/index'
      end

      def lists_function_items
        get '/admin/function_item/list'
        assert_response :success
        assert_template 'admin/function_item/list'
      end

      def shows_function_item(options)
        get '/admin/function_item/show', options
        assert_response :success
        assert_template 'admin/function_item/show'
      end

      def edits_function_item(options)
        get '/admin/function_item/edit', options
        assert_response :success
        assert_template 'admin/function_item/edit'
      end

      def updates_function_item(options)
        post '/admin/function_item/update', options
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_template 'home/index'
      end

      def destroys_function_item(options)
        post '/admin/function_item/destroy', options
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
    
    def check_for_function_item(expected_function_item)
      function_item = FunctionItem.find_by_name(expected_function_item[:name])
      assert_not_nil function_item
      
      assert_equal expected_function_item[:name], function_item.name
      assert_equal expected_function_item[:function_category_item_id], function_item.function_category_item.id
      
      return function_item.id
    end
    
    def new_session
      open_session do |session|
        session.extend(TestingDSL)
        yield session if block_given?
      end
    end    
end
