require "#{File.dirname(__FILE__)}/../test_helper"

class UserItemStoriesTest < ActionController::IntegrationTest
  fixtures :role_items, :user_items, :spexare_items, :configuration_items

  def get_user_item
    {
      :user_name => 'UserName',
      :user_password => 'UserPassword',
      :user_password_confirmation => 'UserPassword',
      :role_item_id => role_items(:test_role_user).id,
      :spexare_item_full_name => spexare_items(:spexare_item_1).full_name
    }
  end
  
  def get_updated_user_item
    {
      :user_name => 'UserNameUpdated',
      :user_password => 'UserPasswordUpdated',
      :user_password_confirmation => 'UserPasswordUpdated',
      :role_item_id => role_items(:test_role_admin).id,
      :spexare_item_full_name => spexare_items(:spexare_item_2).full_name
    }
  end
  
  def test_manage_user_item
    new_session do |admin_user|
      admin_user.goes_to_login
      admin_user.logs_in :user_name => user_items(:test_admin_user).user_name, :user_password => 'TestUserPassword'
      admin_user.instantiates_new_user_item
      admin_user.creates_new_user_item :user_item => get_user_item
      id = check_for_user_item get_user_item
      admin_user.lists_user_items
      admin_user.shows_user_item :id => id
      admin_user.lists_user_items
      admin_user.edits_user_item :id => id
      admin_user.updates_user_item :id => id, :user_item => get_updated_user_item 
      check_for_user_item get_updated_user_item
      admin_user.lists_user_items
      admin_user.destroys_user_item :id => id
      admin_user.logs_out
    end
  end
  
  private
    module TestingDSL
      def instantiates_new_user_item
        get '/admin/user_item/new'
        assert_response :success
        assert_template 'admin/user_item/new'
      end

      def creates_new_user_item(options)
        post '/admin/user_item/create', options
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_template 'home/index'
      end

      def lists_user_items
        get '/admin/user_item/list'
        assert_response :success
        assert_template 'admin/user_item/list'
      end

      def shows_user_item(options)
        get '/admin/user_item/show', options
        assert_response :success
        assert_template 'admin/user_item/show'
      end

      def edits_user_item(options)
        get '/admin/user_item/edit', options
        assert_response :success
        assert_template 'admin/user_item/edit'
      end

      def updates_user_item(options)
        post '/admin/user_item/update', options
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_template 'home/index'
      end

      def destroys_user_item(options)
        post '/admin/user_item/destroy', options
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
    
    def check_for_user_item(expected_user_item)
      user_item = UserItem.find_by_user_name(expected_user_item[:user_name])
      assert_not_nil user_item
      
      assert_equal expected_user_item[:user_name], user_item.user_name
      assert_equal expected_user_item[:role_item_id], user_item.role_item.id
      assert_equal expected_user_item[:spexare_item_full_name], user_item.spexare_item_full_name
      
      return user_item.id
    end
    
    def new_session
      open_session do |session|
        session.extend(TestingDSL)
        yield session if block_given?
      end
    end    
end
