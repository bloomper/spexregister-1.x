require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/user_item_controller'

# Re-raise errors caught by the controller.
class Admin::UserItemController; def rescue_action(e) raise e end; end

class Admin::UserItemControllerTest < Test::Unit::TestCase
  fixtures :role_items, :user_items, :spexare_items, :configuration_items
  
  def setup
    @controller = Admin::UserItemController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index_without_user
    get :index
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :login)
  end

  def test_index_with_non_admin_user
    get :index, {}, {:user_item_id => user_items(:test_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
  end

  def test_index_with_admin_user
    get :index, {}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'list'
    assert_select 'div#titleContainer', 'Visa användare...'
    assert_select 'div#userItemListDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 6
        assert_select 'tr td', user_items(:test_user).user_name
      end
    end
  end
  
  def test_list
    get :index, {}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'list'
    assert_select 'div#titleContainer', 'Visa användare...'
    assert_select 'div#userItemListDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 6
        assert_select 'tr td', user_items(:test_user).user_name
      end
    end
  end

  def test_list_with_filter_options
    get :index, {:filter_options => {:filter => user_items(:test_admin_user).user_name}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'list'
    assert_select 'div#titleContainer', 'Visa användare...'
    assert_select 'div#userItemListDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 2
        assert_select 'tr td', user_items(:test_admin_user).user_name
      end
    end
  end
  
  def test_show
    get :show, {:id => user_items(:test_user).id}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'show'
    assert_select 'div#titleContainer', 'Visa användare...'
    assert_select 'div#userItemDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 8
        assert_select 'tr td:last-child', user_items(:test_user).user_name
      end
    end
  end
  
  def test_show_with_invalid_id
    get :show, {:id => 99}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Ogiltlig användare.', flash[:error]
  end
  
  def test_new
    get :new, {}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'new'
    assert_select 'div#titleContainer', 'Skapa användare...'
    assert_select 'form[action=?]', '/admin/user_item/create' do
      assert_select 'div#userItemDialog' 
      assert_select 'input[id=?]', 'user_item_user_name' 
    end
  end
  
  def test_create
    post :create, {:user_item => {:user_name => 'UserName', :user_password => 'UserPassword', :user_password_confirmation => 'UserPassword', :role_item_id => role_items(:test_role_user).id, :spexare_item_full_name => spexare_items(:spexare_item_1).full_name}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Användaren har skapats.', flash[:message]
  end
  
  def test_create_with_invalid_item
    post :create, {:user_item => {:user_name => nil, :user_password => 'UserPassword', :user_password_confirmation => 'UserPassword', :role_item_id => role_items(:test_role_user).id, :spexare_item_full_name => spexare_items(:spexare_item_1).full_name}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_select 'div#validationErrorsPane' do
      assert_select 'ul li', "Du måste ange 'Användarnamn'."
    end
  end  

  def test_edit
    get :edit, {:id => user_items(:test_user).id}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'edit'
    assert_select 'div#titleContainer', 'Ändra användare...'
    assert_select 'form[action=?]', "/admin/user_item/update/#{user_items(:test_user).id}"
  end
  
  def test_edit_with_invalid_id
    get :edit, {:id => 99}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Ogiltlig användare.', flash[:error]
  end
  
  def test_update
    post :update, {:id => user_items(:test_user).id, :user_item => {:user_name => 'UserName', :user_password => 'UserPassword', :user_password_confirmation => 'UserPassword', :role_item_id => role_items(:test_role_user).id, :spexare_item_full_name => spexare_items(:spexare_item_2).full_name}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Användaren har uppdaterats.', flash[:message]
  end
  
  def test_update_with_invalid_id
    post :update, {:id => 99}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Ogiltlig användare.', flash[:error]
  end

  def test_update_with_invalid_item
    post :update, {:id => user_items(:test_user).id, :user_item => {:user_name => nil, :user_password => 'UserPassword', :user_password_confirmation => 'UserPassword', :role_item_id => role_items(:test_role_user).id, :spexare_item_full_name => "dummy 'dummy' dummy"}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_select 'div#validationErrorsPane' do
      assert_select 'ul li', "Du måste ange 'Användarnamn'."
    end
  end

  def test_destroy
    post :destroy, {:id => user_items(:test_user).id}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Användaren har raderats.', flash[:message]
  end

  def test_destroy_with_invalid_id
    post :destroy, {:id => 99}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Ogiltlig användare.', flash[:error]
  end
  
  def test_destroy_user_in_session
    post :destroy, {:id => user_items(:test_admin_user).id}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Du kan inte radera dig själv.', flash[:error]
  end

  def test_auto_complete
    xhr :get, :auto_complete_for_user_item_spexare_item_full_name, {:user_item => {:spexare_item_full_name => spexare_items(:spexare_item_1).full_name}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_response :success
    assert_select 'ul.userItemDialogSpexareItems' do
      assert_select 'li', :count => 1
      assert_select 'li', spexare_items(:spexare_item_1).full_name.gsub(/[ ]/, '&nbsp;') 
    end
  end
end
