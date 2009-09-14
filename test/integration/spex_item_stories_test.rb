require "#{File.dirname(__FILE__)}/../test_helper"

class SpexItemStoriesTest < ActionController::IntegrationTest
  fixtures :role_items, :user_items, :spex_category_items, :configuration_items

  def get_spex_item
    {
      :year => '2099',
      :title => 'Title',
      :spex_category_item_id => spex_category_items(:test_category_1).id
    }
  end
  
  def get_updated_spex_item
    {
      :year => '2098',
      :title => 'TitleUpdated',
      :spex_category_item_id => spex_category_items(:test_category_2).id
    }
  end
  
  def test_manage_spex_item
    new_session do |admin_user|
      admin_user.goes_to_login
      admin_user.logs_in :user_name => user_items(:test_admin_user).user_name, :user_password => 'TestUserPassword'
      admin_user.instantiates_new_spex_item
      admin_user.creates_new_spex_item :spex_item => get_spex_item
      id = check_for_spex_item get_spex_item
      admin_user.lists_spex_items
      admin_user.shows_spex_item :id => id
      admin_user.lists_spex_items
      admin_user.edits_spex_item :id => id
      admin_user.updates_spex_item :id => id, :spex_item => get_updated_spex_item 
      check_for_spex_item get_updated_spex_item
      admin_user.lists_spex_items
      admin_user.destroys_spex_item :id => id
      admin_user.logs_out
    end
  end
  
  private
    module TestingDSL
      def instantiates_new_spex_item
        get '/admin/spex_item/new'
        assert_response :success
        assert_template 'admin/spex_item/new'
      end

      def creates_new_spex_item(options)
        post '/admin/spex_item/create', options
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_template 'home/index'
      end

      def lists_spex_items
        get '/admin/spex_item/list'
        assert_response :success
        assert_template 'admin/spex_item/list'
      end

      def shows_spex_item(options)
        get '/admin/spex_item/show', options
        assert_response :success
        assert_template 'admin/spex_item/show'
      end

      def edits_spex_item(options)
        get '/admin/spex_item/edit', options
        assert_response :success
        assert_template 'admin/spex_item/edit'
      end

      def updates_spex_item(options)
        post '/admin/spex_item/update', options
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_template 'home/index'
      end

      def destroys_spex_item(options)
        post '/admin/spex_item/destroy', options
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
    
    def check_for_spex_item(expected_spex_item)
      spex_item = SpexItem.find_by_year(expected_spex_item[:year])
      assert_not_nil spex_item
      
      assert_equal expected_spex_item[:year], spex_item.year
      assert_equal expected_spex_item[:title], spex_item.title
      assert_equal expected_spex_item[:spex_category_item_id], spex_item.spex_category_item.id
      
      return spex_item.id
    end
    
    def new_session
      open_session do |session|
        session.extend(TestingDSL)
        yield session if block_given?
      end
    end    
end
