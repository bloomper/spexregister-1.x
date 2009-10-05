require 'test_helper'

class SpexControllerTest < ActionController::TestCase
  def setup
    create_user_session(users(:admin))
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:spex)
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should create spex" do
    assert_difference('Spex.count') do
      post :create, :spex => { :year => '2098', :title => Time.now, :spex_category => spex_categories(:spex_category) }
    end
    
    assert_redirected_to spex_path(assigns(:spex))
  end
  
  test "should show spex" do
    get :show, :id => spex(:spex_1).id
    assert_response :success
  end
  
  test "should get edit" do
    get :edit, :id => spex(:spex_1).id
    assert_response :success
  end
  
  test "should update spex" do
    put :update, :id => spex(:spex_1).id, :spex => { :year => '2098' }
    assert_redirected_to spex_path(assigns(:spex))
  end
  
  test "should destroy spex" do
    assert_difference('Spex.count', -1) do
      delete :destroy, :id => spex(:spex_1).id
    end
    assert_redirected_to spex_path
  end
end
