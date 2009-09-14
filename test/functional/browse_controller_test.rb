require File.dirname(__FILE__) + '/../test_helper'
require 'browse_controller'

# Re-raise errors caught by the controller.
class BrowseController; def rescue_action(e) raise e end; end

class BrowseControllerTest < Test::Unit::TestCase
  fixtures :role_items, :user_items, :news_items, :spexare_items, :link_items, :spex_items, :spex_category_items, :function_items, :function_category_items, :configuration_items

  def setup
    @controller = BrowseController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index_without_user
    get :index
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :login)
  end

  def test_index_with_user
    get :index, {}, {:user_item_id => user_items(:test_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
  end

  def test_show
    get :show, {:id => spexare_items(:spexare_item_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_template 'show'
    assert_select 'div#titleContainer', 'Visa spexare...'
    assert_select 'div#spexareItemDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 21
      end
    end
  end
  
  def test_show_with_invalid_id
    get :show, {:id => 99}, {:user_item_id => user_items(:test_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Ogiltlig spexare.', flash[:error]
  end
  
  def test_edit
    get :edit, {:id => spexare_items(:spexare_item_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_template 'edit'
    assert_select 'div#titleContainer', 'Ändra spexare...'
    assert_select 'form[action=?]', "/browse/update/#{spexare_items(:spexare_item_1).id}"
  end
  
  def test_edit_with_invalid_id
    get :edit, {:id => 99}, {:user_item_id => user_items(:test_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Du har ej rättigheter till att utföra detta.', flash[:error]
  end
  
  def test_update
    post :update, {:id => spexare_items(:spexare_item_1).id, :spexare_item => {:last_name => 'LastName', :first_name => 'FirstName', :related_spexare_item_full_name => spexare_items(:spexare_item_2).full_name}}, {:user_item_id => user_items(:test_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Spexaren har uppdaterats.', flash[:message]
  end
  
  def test_update_with_picture
    post :update, {:id => spexare_items(:spexare_item_1).id, :spexare_item => {:last_name => 'LastName', :first_name => 'FirstName', :spexare_picture_item => upload_file(:class => SpexarePictureItem, :filename => '/files/rails.png', :content_type => 'image/png')}}, {:user_item_id => user_items(:test_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Spexaren har uppdaterats.', flash[:message]
  end

  def test_update_with_picture_removed
    post :update, {:id => spexare_items(:spexare_item_1).id, :spexare_item => {:last_name => 'LastName', :first_name => 'FirstName'}, :picture_removed => 'true'}, {:user_item_id => user_items(:test_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Spexaren har uppdaterats.', flash[:message]
  end

  def test_update_with_invalid_id
    post :update, {:id => 99}, {:user_item_id => user_items(:test_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Du har ej rättigheter till att utföra detta.', flash[:error]
  end

  def test_update_with_invalid_item
    post :update, {:id => spexare_items(:spexare_item_1).id, :spexare_item => {:last_name => nil, :first_name => 'FirstName'}}, {:user_item_id => user_items(:test_user).id}
    assert_select 'div#validationErrorsPane' do
      assert_select 'ul li', "Du måste ange 'Efternamn'."
    end
  end

  def test_destroy
    post :destroy, {:id => spexare_items(:spexare_item_1).id}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Spexaren har raderats.', flash[:message]
  end

  def test_destroy_with_non_admin_user
    post :destroy, {:id => spexare_items(:spexare_item_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
  end

  def test_destroy_with_invalid_id
    post :destroy, {:id => 99}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Ogiltlig spexare.', flash[:error]
  end
  
  def test_new_link_item
    xhr :get, :new_link_item, {:spexare_item_id => spexare_items(:spexare_item_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'spexareItemLinksTBody'
  end
  
  def test_add_link_item
    xhr :post, :add_link_item, {:link_item => { :spex_item => { :id => "#{spex_items(:test_spex_1).id}" }, :function_items => ["#{function_items(:test_function_2).id}"], :actor_item => {:vocal => [ ActorItem::VOCAL_TYPES[1][1] ], :role => ['Test']}}, :spexare_item_id => spexare_items(:spexare_item_1).id, :parent_action => 'edit'}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'spexareItemLinksTBody'
  end
  
  def test_add_link_item_without_parent_action
    xhr :post, :add_link_item, {:link_item => { :spex_item => { :id => "#{spex_items(:test_spex_1).id}" }, :function_items => ["#{function_items(:test_function_2).id}"], :actor_item => {:vocal => [ ActorItem::VOCAL_TYPES[1][1] ], :role => ['Test']}}, :spexare_item_id => spexare_items(:spexare_item_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'spexareItemLinksTBody'
  end

  def test_add_link_item_with_invalid_spex_id
    xhr :post, :add_link_item, {:link_item => { :spex_item => { :id => "99" }, :function_items => ["#{function_items(:test_function_2).id}"], :actor_item => {:vocal => [ ActorItem::VOCAL_TYPES[1][1] ], :role => ['Test']}}, :spexare_item_id => spexare_items(:spexare_item_1).id, :parent_action => 'edit'}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'errorPane' do
      assert_select 'ul li', 'Ogiltligt spex.'
    end
  end

  def test_add_link_item_with_invalid_function_id
    xhr :post, :add_link_item, {:link_item => { :spex_item => { :id => "#{spex_items(:test_spex_1).id}" }, :function_items => ["99"], :actor_item => {:vocal => [ ActorItem::VOCAL_TYPES[1][1] ], :role => ['Test']}}, :spexare_item_id => spexare_items(:spexare_item_1).id, :parent_action => 'edit'}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'errorPane' do
      assert_select 'ul li', 'Ogiltlig funktion.'
    end
  end

  def test_add_link_item_with_invalid_spexare_id
    xhr :post, :add_link_item, {:link_item => { :spex_item => { :id => "#{spex_items(:test_spex_1).id}" }, :function_items => ["#{function_items(:test_function_2).id}"], :actor_item => {:vocal => [ ActorItem::VOCAL_TYPES[1][1] ], :role => ['Test']}}, :spexare_item_id => 99, :parent_action => 'edit'}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'errorPane' do
      assert_select 'ul li', 'Du har ej rättigheter till att utföra detta.'
    end
  end
  
  def test_edit_link_item
    xhr :get, :edit_link_item, {:link_item_id => link_items(:test_link_item_1).id, :parent_action => 'edit', :spexare_item_id => spexare_items(:spexare_item_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'spexareItemLinksTBody'
  end
  
  def test_edit_link_item_with_invalid_id
    xhr :post, :edit_link_item, {:link_item_id => 99, :parent_action => 'edit', :spexare_item_id => spexare_items(:spexare_item_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'errorPane' do
      assert_select 'ul li', 'Ogiltlig länk.'
    end
  end

  def test_update_link_item
    xhr :post, :update_link_item, {:link_item_id => link_items(:test_link_item_1).id, :link_item => { :spex_item => { :id => "#{spex_items(:test_spex_1).id}" }, :function_items => ["#{function_items(:test_function_2).id}"], :actor_item => {:vocal => [ ActorItem::VOCAL_TYPES[1][1] ], :role => ['Test']}}, :spexare_item_id => spexare_items(:spexare_item_1).id, :parent_action => 'edit'}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'spexareItemLinksTBody'
  end
  
  def test_update_link_item_with_invalid_link_id
    xhr :post, :update_link_item, {:link_item_id => 99, :link_item => { :spex_item => { :id => "#{spex_items(:test_spex_1).id}" }, :function_items => ["#{function_items(:test_function_2).id}"], :actor_item => {:vocal => [ ActorItem::VOCAL_TYPES[1][1] ], :role => ['Test']}}, :spexare_item_id => spexare_items(:spexare_item_1).id, :parent_action => 'edit'}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'errorPane' do
      assert_select 'ul li', 'Ogiltlig länk.'
    end
  end

  def test_update_link_item_with_invalid_spex_id
    xhr :post, :update_link_item, {:link_item_id => link_items(:test_link_item_1).id, :link_item => { :spex_item => { :id => "99" }, :function_items => ["#{function_items(:test_function_2).id}"], :actor_item => {:vocal => [ ActorItem::VOCAL_TYPES[1][1] ], :role => ['Test']}}, :spexare_item_id => spexare_items(:spexare_item_1).id, :parent_action => 'edit'}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'errorPane' do
      assert_select 'ul li', 'Ogiltligt spex.'
    end
  end

  def test_update_link_item_with_invalid_function_id
    xhr :post, :update_link_item, {:link_item_id => link_items(:test_link_item_1).id, :link_item => { :spex_item => { :id => "#{spex_items(:test_spex_1).id}" }, :function_items => ["99"], :actor_item => {:vocal => [ ActorItem::VOCAL_TYPES[1][1] ], :role => ['Test']}}, :spexare_item_id => spexare_items(:spexare_item_1).id, :parent_action => 'edit'}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'errorPane' do
      assert_select 'ul li', 'Ogiltlig funktion.'
    end
  end
  
  def test_cancel_link_item
    xhr :get, :cancel_link_item, {:link_item_id => 'dummy', :spexare_item_id => spexare_items(:spexare_item_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
  end
  
  def test_destroy_link_item
    xhr :post, :destroy_link_item, {:link_item_id => link_items(:test_link_item_1).id, :parent_action => 'edit', :spexare_item_id => spexare_items(:spexare_item_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
  end
  
  def test_destroy_link_item_with_invalid_id
    xhr :post, :destroy_link_item, {:link_item_id => 99, :parent_action => 'edit', :spexare_item_id => spexare_items(:spexare_item_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'errorPane' do
      assert_select 'ul li', 'Ogiltlig länk.'
    end
  end

  def test_move_up_link_item
    xhr :post, :move_up_link_item, {:link_item_id => link_items(:test_link_item_1).id, :parent_action => 'edit', :spexare_item_id => spexare_items(:spexare_item_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
  end
  
  def test_move_up_link_item_with_invalid_id
    xhr :post, :move_up_link_item, {:link_item_id => 99, :parent_action => 'edit', :spexare_item_id => spexare_items(:spexare_item_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'errorPane' do
      assert_select 'ul li', 'Ogiltlig länk.'
    end
  end

  def test_move_down_link_item
    xhr :post, :move_down_link_item, {:link_item_id => link_items(:test_link_item_1).id, :parent_action => 'edit', :spexare_item_id => spexare_items(:spexare_item_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
  end

  def test_move_down_link_item_with_invalid_id
    xhr :post, :move_down_link_item, {:link_item_id => 99, :parent_action => 'edit', :spexare_item_id => spexare_items(:spexare_item_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'errorPane' do
      assert_select 'ul li', 'Ogiltlig länk.'
    end
  end
  
  def test_find_spex_years_by_category
    xhr :get, :find_spex_years_by_category, {:spex_category_item_id => spex_category_items(:test_category_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select 'select' do
      assert_select 'option', :count => 2
    end
  end
  
  def test_find_spex_titles_by_category
    xhr :get, :find_spex_titles_by_category, {:spex_category_item_id => spex_category_items(:test_category_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select 'select' do
      assert_select 'option', :count => 2
    end
  end
  
  def test_auto_complete_for_spexare_item_related_spexare_item_full_name
    xhr :get, :auto_complete_for_spexare_item_related_spexare_item_full_name, {:spexare_item_related_spexare_item_full_name => spexare_items(:spexare_item_2).full_name, :spexare_item_id => spexare_items(:spexare_item_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select 'ul.spexareItemDialogRelatedSpexareItems' do
      assert_select 'li', :count => 1
      assert_select 'li', spexare_items(:spexare_item_2).full_name.gsub(/[ ]/, '&nbsp;') 
    end
  end

  private
    def upload_file(options = {})
      att = options[:class].create :uploaded_data => fixture_file_upload(options[:filename], options[:content_type] || 'image/png')
      att.reload unless att.new_record?
      att
    end

end
