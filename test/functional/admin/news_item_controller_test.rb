require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/news_item_controller'

# Re-raise errors caught by the controller.
class Admin::NewsItemController; def rescue_action(e) raise e end; end

class Admin::NewsItemControllerTest < Test::Unit::TestCase
  fixtures :role_items, :user_items, :news_items, :configuration_items

  def setup
    @controller = Admin::NewsItemController.new
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
    assert_select 'div#titleContainer', 'Visa nyheter...'
    assert_select 'div#newsItemListDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 3
        assert_select 'tr td', news_items(:test_news_1).publication_date
      end
    end
  end
  
  def test_list
    get :index, {}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'list'
    assert_select 'div#titleContainer', 'Visa nyheter...'
    assert_select 'div#newsItemListDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 3
        assert_select 'tr td', news_items(:test_news_1).publication_date
      end
    end
  end

  def test_list_with_filter_options
    get :index, {:filter_options => {:filter => news_items(:test_news_2).body}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'list'
    assert_select 'div#titleContainer', 'Visa nyheter...'
    assert_select 'div#newsItemListDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 2
        assert_select 'tr td', news_items(:test_news_2).publication_date
      end
    end
  end
  
  def test_show
    get :show, {:id => news_items(:test_news_1).id}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'show'
    assert_select 'div#titleContainer', 'Visa nyhet...'
    assert_select 'div#newsItemDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 6
        assert_select 'tr td:last-child', news_items(:test_news_1).publication_date
      end
    end
  end
  
  def test_show_with_invalid_id
    get :show, {:id => 99}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Ogiltlig nyhet.', flash[:error]
  end
  
  def test_new
    get :new, {}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'new'
    assert_select 'div#titleContainer', 'Skapa nyhet...'
    assert_select 'form[action=?]', '/admin/news_item/create' do
      assert_select 'div#newsItemDialog' 
      assert_select 'input[id=?]', 'news_item_publication_date' 
    end
  end
  
  def test_create
    post :create, {:news_item => {:publication_date => '2099-03-01', :subject => 'TestSubjectAgain', :body => 'TestBodyAgain'}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Nyheten har skapats.', flash[:message]
  end
  
  def test_create_with_invalid_item
    post :create, {:news_item => {:publication_date => '2099-03-01', :subject => nil, :body => nil}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_select 'div#validationErrorsPane' do
      assert_select 'ul li', "Du måste ange 'Text'."
    end
  end  

  def test_edit
    get :edit, {:id => news_items(:test_news_1).id}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'edit'
    assert_select 'div#titleContainer', 'Ändra nyhet...'
    assert_select 'form[action=?]', "/admin/news_item/update/#{news_items(:test_news_1).id}"
  end
  
  def test_edit_with_invalid_id
    get :edit, {:id => 99}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Ogiltlig nyhet.', flash[:error]
  end
  
  def test_update
    post :update, {:id => news_items(:test_news_1).id, :news_item => {:publication_date => '2099-03-01', :subject => 'TestSubjectAgain', :body => 'TestBodyAgain'}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Nyheten har uppdaterats.', flash[:message]
  end
  
  def test_update_with_invalid_id
    post :update, {:id => 99}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Ogiltlig nyhet.', flash[:error]
  end

  def test_update_with_invalid_item
    post :update, {:id => news_items(:test_news_1).id, :news_item => {:publication_date => '2099-03-01', :subject => nil, :body => nil}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_select 'div#validationErrorsPane' do
      assert_select 'ul li', "Du måste ange 'Text'."
    end
  end

  def test_destroy
    post :destroy, {:id => news_items(:test_news_1).id}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Nyheten har raderats.', flash[:message]
  end

  def test_destroy_with_invalid_id
    post :destroy, {:id => 99}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Ogiltlig nyhet.', flash[:error]
  end
end
