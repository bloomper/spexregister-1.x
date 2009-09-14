require "#{File.dirname(__FILE__)}/../test_helper"

class SpexareItemStoriesTest < ActionController::IntegrationTest
  fixtures :role_items, :user_items, :spex_items, :spex_category_items, :function_items, :function_category_items, :configuration_items

  def get_spexare_item
    {
      :last_name => 'LastName',
      :first_name => 'FirstName',
    }
  end
  
  def get_updated_spexare_item
    {
      :last_name => 'LastNameUpdated',
      :first_name => 'FirstNameUpdated'
    }
  end

  def get_link_item
    {
      :spex_item => { :id => "#{spex_items(:test_spex_1).id}" },
      :function_items => ["#{function_items(:test_function_2).id}"],
      :actor_item => {:vocal => [ ActorItem::VOCAL_TYPES[1][1] ], :role => ['Test']}
    }
  end

  def get_updated_link_item
    {
      :spex_item => { :id => "#{spex_items(:test_spex_1).id}" },
      :function_items => ["#{function_items(:test_function_1).id}"]
    }
  end

  def test_manage_spex_item
    new_session do |admin_user|
      admin_user.goes_to_login
      admin_user.logs_in :user_name => user_items(:test_admin_user).user_name, :user_password => 'TestUserPassword'
      admin_user.instantiates_new_spexare_item
      admin_user.creates_new_spexare_item :spexare_item => get_spexare_item
      id = check_for_spexare_item get_spexare_item
      admin_user.instantiates_new_link_item
      admin_user.adds_new_link_item :link_item => get_link_item, :spexare_item_id => id, :parent_action => 'edit'
      link_id = check_for_link_item get_spexare_item
      admin_user.lists_spexare_items
      admin_user.shows_spexare_item :id => id
      admin_user.lists_spexare_items
      admin_user.edits_spexare_item :id => id
      admin_user.updates_spexare_item :id => id, :spexare_item => get_updated_spexare_item 
      check_for_spexare_item get_updated_spexare_item
      admin_user.edits_link_item :link_item_id => link_id, :spexare_item_id => id, :parent_action => 'edit'
      admin_user.updates_link_item :link_item_id => link_id, :link_item => get_updated_link_item, :spexare_item_id => id, :parent_action => 'edit'
      check_for_link_item get_updated_spexare_item
      admin_user.edits_link_item :link_item_id => link_id, :spexare_item_id => id, :parent_action => 'edit'
      admin_user.destroys_link_item :link_item_id => link_id, :spexare_item_id => id, :parent_action => 'edit'
      admin_user.lists_spexare_items
      #admin_user.destroys_spexare_item :id => id
      admin_user.logs_out
    end
  end
  
  private
    module TestingDSL
      def instantiates_new_spexare_item
        get '/admin/spexare_item/new'
        assert_response :success
        assert_template 'admin/spexare_item/new'
      end

      def creates_new_spexare_item(options)
        post '/admin/spexare_item/create', options
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_template 'home/index'
      end

      def lists_spexare_items
        get '/admin/spexare_item/list'
        assert_response :success
        assert_template 'admin/spexare_item/list'
      end

      def shows_spexare_item(options)
        get '/admin/spexare_item/show', options
        assert_response :success
        assert_template 'admin/spexare_item/show'
      end

      def edits_spexare_item(options)
        get '/admin/spexare_item/edit', options
        assert_response :success
        assert_template 'admin/spexare_item/edit'
      end

      def updates_spexare_item(options)
        post '/admin/spexare_item/update', options
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_template 'home/index'
      end

      def destroys_spexare_item(options)
        post '/admin/spexare_item/destroy', options
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_template 'home/index'
      end

      def instantiates_new_link_item
        get '/admin/spexare_item/new_link_item'
        assert_response :success
        assert_template 'admin/spexare_item/new_link_item'
      end

      def adds_new_link_item(options)
        post '/admin/spexare_item/add_link_item', options
        assert_response :success
        assert_template 'admin/spexare_item/add_link_item'
      end

      def edits_link_item(options)
        get '/admin/spexare_item/edit_link_item', options
        assert_response :success
        assert_template 'admin/spexare_item/edit_link_item'
      end

      def updates_link_item(options)
        post '/admin/spexare_item/update_link_item', options
        assert_response :success
        assert_template 'admin/spexare_item/update_link_item'
      end

      def destroys_link_item(options)
        post '/admin/spexare_item/destroy_link_item', options
        assert_response :success
        assert_template 'admin/spexare_item/destroy_link_item'
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
    
    def check_for_spexare_item(expected_spexare_item)
      spexare_item = SpexareItem.find_by_last_name(expected_spexare_item[:last_name])
      assert_not_nil spexare_item
      
      assert_equal expected_spexare_item[:last_name], spexare_item.last_name
      assert_equal expected_spexare_item[:first_name], spexare_item.first_name
      
      return spexare_item.id
    end
    
    def check_for_link_item(expected_spexare_item)
      spexare_item = SpexareItem.find_by_last_name(expected_spexare_item[:last_name])
      assert_not_nil spexare_item.link_items
      assert_not_nil spexare_item.link_items[0]
     
      return spexare_item.link_items[0].id
    end

    def new_session
      open_session do |session|
        session.extend(TestingDSL)
        yield session if block_given?
      end
    end    
end
