require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/home_controller'

# Re-raise errors caught by the controller.
class Admin::HomeController; def rescue_action(e) raise e end; end

class Admin::HomeControllerTest < Test::Unit::TestCase
  fixtures :role_items, :user_items, :configuration_items

  def setup
    @controller = Admin::HomeController.new
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
    assert_template 'index'
  end
end
