require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/spex_item_controller'

# Re-raise errors caught by the controller.
class Admin::SpexItemController; def rescue_action(e) raise e end; end

class Admin::SpexItemControllerTest < Test::Unit::TestCase
  fixtures :role_items, :user_items, :spex_category_items, :spex_items, :configuration_items

  def setup
    @controller = Admin::SpexItemController.new
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
    assert_select 'div#titleContainer', 'Visa spex...'
    assert_select 'div#spexItemListDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 3
        assert_select 'tr td', spex_items(:test_spex_1).year
      end
    end
  end
  
  def test_list
    get :index, {}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'list'
    assert_select 'div#titleContainer', 'Visa spex...'
    assert_select 'div#spexItemListDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 3
        assert_select 'tr td', spex_items(:test_spex_1).year
      end
    end
  end

  def test_list_with_filter_options
    get :index, {:filter_options => {:filter => spex_items(:test_spex_2).year}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'list'
    assert_select 'div#titleContainer', 'Visa spex...'
    assert_select 'div#spexItemListDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 2
        assert_select 'tr td', spex_items(:test_spex_2).year
      end
    end
  end
  
  def test_show
    get :show, {:id => spex_items(:test_spex_1).id}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'show'
    assert_select 'div#titleContainer', 'Visa spex...'
    assert_select 'div#spexItemDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 7
        assert_select 'tr td:last-child', spex_items(:test_spex_1).year
      end
    end
  end
  
  def test_show_with_invalid_id
    get :show, {:id => 99}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Ogiltligt spex.', flash[:error]
  end
  
  def test_new
    get :new, {}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'new'
    assert_select 'div#titleContainer', 'Skapa spex...'
    assert_select 'form[action=?]', '/admin/spex_item/create' do
      assert_select 'div#spexItemDialog' 
      assert_select 'input[id=?]', "spex_item_year" 
    end
  end
  
  def test_create
    post :create, {:spex_item => {:year => '2099', :title => 'Title', :spex_category_item_id => spex_category_items(:test_category_1).id}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Spexet har skapats.', flash[:message]
  end
  
  def test_create_with_poster
    post :create, {:spex_item => {:year => '2099', :title => 'Title', :spex_category_item_id => spex_category_items(:test_category_1).id, :spex_poster_item => upload_file(:class => SpexPosterItem, :filename => '/files/rails.png', :content_type => 'image/png')}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Spexet har skapats.', flash[:message]
  end

  def test_create_with_invalid_item
    post :create, {:spex_item => {:year => nil, :title => 'Title', :spex_category_item_id => spex_category_items(:test_category_1).id}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_select 'div#validationErrorsPane' do
      assert_select 'ul li', "Du måste ange 'År'."
    end
  end  

  def test_edit
    get :edit, {:id => spex_items(:test_spex_1).id}, {:user_item_id => user_items(:test_admin_user).id}
    assert_template 'edit'
    assert_select 'div#titleContainer', 'Ändra spex...'
    assert_select 'form[action=?]', "/admin/spex_item/update/#{spex_items(:test_spex_1).id}"
  end
  
  def test_edit_with_invalid_id
    get :edit, {:id => 99}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Ogiltligt spex.', flash[:error]
  end
  
  def test_update
    post :update, {:id => spex_items(:test_spex_1).id, :spex_item => {:year => '2099', :title => 'Title', :spex_category_item_id => spex_category_items(:test_category_1).id}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Spexet har uppdaterats.', flash[:message]
  end
  
  def test_update_with_poster
    post :update, {:id => spex_items(:test_spex_1).id, :spex_item => {:year => '2099', :title => 'Title', :spex_category_item_id => spex_category_items(:test_category_1).id, :spex_poster_item => upload_file(:class => SpexPosterItem, :filename => '/files/rails.png', :content_type => 'image/png')}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Spexet har uppdaterats.', flash[:message]
  end

  def test_update_with_poster_removed
    post :update, {:id => spex_items(:test_spex_1).id, :spex_item => {:year => '2099', :title => 'Title', :spex_category_item_id => spex_category_items(:test_category_1).id}, :poster_removed => 'true'}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Spexet har uppdaterats.', flash[:message]
  end

  def test_update_with_invalid_id
    post :update, {:id => 99}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Ogiltligt spex.', flash[:error]
  end

  def test_update_with_invalid_item
    post :update, {:id => spex_items(:test_spex_1).id, :spex_item => {:year => nil, :title => 'Title', :spex_category_item_id => spex_category_items(:test_category_1).id, :spex_poster_item => nil}}, {:user_item_id => user_items(:test_admin_user).id}
    assert_select 'div#validationErrorsPane' do
      assert_select 'ul li', "Du måste ange 'År'."
    end
  end

  def test_destroy
    post :destroy, {:id => spex_items(:test_spex_1).id}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Spexet har raderats.', flash[:message]
  end

  def test_destroy_with_invalid_id
    post :destroy, {:id => 99}, {:user_item_id => user_items(:test_admin_user).id}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Ogiltligt spex.', flash[:error]
  end

  private
    def upload_file(options = {})
      att = options[:class].create :uploaded_data => fixture_file_upload(options[:filename], options[:content_type] || 'image/png')
      att.reload unless att.new_record?
      att
    end
end
