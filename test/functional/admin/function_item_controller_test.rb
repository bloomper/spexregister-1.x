require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/function_item_controller'

# Re-raise errors caught by the controller.
class Admin::FunctionItemController; def rescue_action(e) raise e end; end

class Admin::FunctionItemControllerTest < Test::Unit::TestCase
  fixtures :role_items, :user_items, :function_category_items, :function_items, :configuration_items

  def setup
    @controller = Admin::FunctionItemController.new
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
    assert_select 'div#titleContainer', 'Visa funktioner...'
    assert_select 'div#functionItemListDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 3
        assert_select 'tr td', function_items(:test_function_1).name
      end
    end
  end
  
  def test_list
    get :index, {}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'list'
    assert_select 'div#titleContainer', 'Visa funktioner...'
    assert_select 'div#functionItemListDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 3
        assert_select 'tr td', function_items(:test_function_1).name
      end
    end
  end

  def test_list_with_filter_options
    get :index, {:filter_options => {:filter => function_items(:test_function_2).name}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'list'
    assert_select 'div#titleContainer', 'Visa funktioner...'
    assert_select 'div#functionItemListDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 2
        assert_select 'tr td', function_items(:test_function_2).name
      end
    end
  end
  
  def test_show
    get :show, {:id => function_items(:test_function_1).id}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'show'
    assert_select 'div#titleContainer', 'Visa funktion...'
    assert_select 'div#functionItemDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 5
        assert_select 'tr td:last-child', function_items(:test_function_1).name
      end
    end
  end
  
  def test_show_with_invalid_id
    get :show, {:id => 99}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Ogiltlig funktion.', flash[:error]
  end
  
  def test_new
    get :new, {}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'new'
    assert_select 'div#titleContainer', 'Skapa funktion...'
    assert_select 'form[action=?]', '/admin/function_item/create' do
      assert_select 'div#functionItemDialog' 
      assert_select 'input[id=?]', 'function_item_name' 
    end
  end
  
  def test_create
    post :create, {:function_item => {:name => 'Name', :function_category_item_id => function_category_items(:test_category_1).id}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Funktionen har skapats.', flash[:message]
  end
  
  def test_create_with_invalid_item
    post :create, {:function_item => {:name => nil, :function_category_item_id => function_category_items(:test_category_1).id}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_select 'div#validationErrorsPane' do
      assert_select 'ul li', "Du måste ange 'Namn'."
    end
  end  

  def test_edit
    get :edit, {:id => function_items(:test_function_1).id}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'edit'
    assert_select 'div#titleContainer', 'Ändra funktion...'
    assert_select 'form[action=?]', "/admin/function_item/update/#{function_items(:test_function_1).id}"
  end
  
  def test_edit_with_invalid_id
    get :edit, {:id => 99}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Ogiltlig funktion.', flash[:error]
  end
  
  def test_update
    post :update, {:id => function_items(:test_function_1).id, :function_item => {:name => 'Name', :function_category_item_id => function_category_items(:test_category_1).id}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Funktionen har uppdaterats.', flash[:message]
  end
  
  def test_update_with_invalid_id
    post :update, {:id => 99}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Ogiltlig funktion.', flash[:error]
  end

  def test_update_with_invalid_item
    post :update, {:id => function_items(:test_function_1).id, :function_item => {:name => nil, :function_category_item_id => function_category_items(:test_category_1).id}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_select 'div#validationErrorsPane' do
      assert_select 'ul li', "Du måste ange 'Namn'."
    end
  end

  def test_destroy
    post :destroy, {:id => function_items(:test_function_1).id}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Funktionen har raderats.', flash[:message]
  end

  def test_destroy_with_invalid_id
    post :destroy, {:id => 99}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Ogiltlig funktion.', flash[:error]
  end
end
