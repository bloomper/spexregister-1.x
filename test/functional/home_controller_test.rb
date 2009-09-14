require File.dirname(__FILE__) + '/../test_helper'
require 'home_controller'

# Re-raise errors caught by the controller.
class HomeController; def rescue_action(e) raise e end; end

class HomeControllerTest < Test::Unit::TestCase
  fixtures :role_items, :user_items, :spexare_items, :news_items, :configuration_items

  def setup
    @controller = HomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @emails     = ActionMailer::Base.deliveries
    @emails.clear
  end

  def test_index_without_user
    get :index
    assert_redirected_to @controller.url_for(:action => :login)
  end
  
  def test_index_with_user
    get :index, {}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_template 'index'
    assert_select 'div#titleContainer', 'Senaste nyheterna...'
    assert_select 'div#newsItemListDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 2
        assert_select 'tr td', news_items(:test_news_1).publication_date
      end
    end
  end

  def test_index_with_user_with_temporary_password
    get :index, {}, {:user_item_id => user_items(:test_user_with_temporary_password).id}
    assert_redirected_to @controller.url_for(:action => :change_my_password)
    assert_equal 'Eftersom detta är första gången du loggar in så måste du byta ditt tillfälliga lösenord.', flash[:message]
    follow_redirect
    assert_template 'change_my_password'
    assert_select 'div#titleContainer', 'Ändra lösenord...'
    assert_select 'form[action=?]', '/home/change_my_password' do
      assert_select 'div#changeMyPasswordDialog' 
      assert_select 'input[id=?]', 'user_item_user_password' 
    end
  end
  
  def test_login
    user_item = user_items(:test_user)
    post :login, :user_name => user_item.user_name, :user_password => 'TestUserPassword'
    assert_redirected_to @controller.url_for(:action => :index)
    assert_equal user_item.id, session[:user_item_id]
  end

  def test_login_with_bad_password
    user_item = user_items(:test_user)
    post :login, :user_name => user_item.user_name, :user_password => 'IncorrectPassword'
    assert_template 'login'
    assert_equal 'Felaktigt användarnamn och/eller lösenord.', flash[:error]
  end

  def test_login_with_disabled_user
    user_item = user_items(:test_user_disabled)
    post :login, :user_name => user_item.user_name, :user_password => 'TestUserPassword'
    assert_template 'login'
    assert flash[:error].include?('Användaren är deaktiverad och kan inte logga in.')
  end

  def test_logout
    get :logout, {}, {:user_item_id => user_items(:test_user).id}
    assert_redirected_to @controller.url_for(:action => :login)
    assert_nil session[:user_item_id]
    assert_equal 'Du har blivit utloggad.', flash[:message]
    follow_redirect
    assert_select 'form[action=?]', '/home/login' do
      assert_select 'div#loginDialog' 
      assert_select 'input[id=?]', 'user_name' 
    end
  end
  
  def test_show_signup
    xhr :get, :show_signup
    assert_response :success
    assert_select_rjs 'signupDialog'
  end
  
  def test_hide_signup
    xhr :get, :hide_signup
    assert_response :success
  end

  def test_signup
    xhr :post, :signup, {:new_account_email_address => 'testemailaddress@test.se', :new_account_name=> 'TestName', :new_account_user_name => 'TestUserName', :new_account_description => 'TestDescription'}
    assert_response :success
    assert_select_rjs 'messagePane' do
      assert_select 'ul li', 'Meddelandet har skickats.'
    end
    email = @emails.first
    assert_equal 'Meddelande från Chalmersspexets Adressregister', email.subject
    assert_equal ConfigurationItem.find_by_name(ConfigurationItem::ADMIN_MAIL_ADDRESS).value, email.to[0]
    assert_equal 'testemailaddress@test.se', email.from[0]
    assert_match /skulle vilja ha tillgång/, email.body
  end

  def test_show_news_item
    xhr :get, :show_news_item, {:id => news_items(:test_news_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'latestNewsDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 4
        assert_select 'tr td', news_items(:test_news_1).publication_date
      end
    end
  end

  def test_show_news_item_invalid
    xhr :get, :show_news_item, {:id => 99}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'errorPane' do
      assert_select 'ul li', 'Ogiltlig nyhet.'
    end
  end

  def test_change_my_password
    post :change_my_password, {:user_item => {:user_password => 'TestPassword', :user_password_confirmation => 'TestPassword'}}, {:user_item_id => user_items(:test_user).id}
    assert_redirected_to @controller.url_for(:action => :index)
    assert_equal 'Lösenordet är uppdaterat.', flash[:message]
  end

  def test_change_my_password_with_invalid_user_in_session
    post :change_my_password, {:user_item => {:user_password => 'TestPassword', :user_password_confirmation => 'TestPassword'}}, {:user_item_id => 99}
    assert_redirected_to @controller.url_for(:action => :login)
  end

  def test_change_my_password_with_validation_errors
    post :change_my_password, {:user_item => {:user_password => 'TestPassword', :user_password_confirmation => 'TestPassword2'}}, {:user_item_id => user_items(:test_user).id}
    assert_select 'div#validationErrorsPane' do
      assert_select 'ul li', "Angivna 'Lösenord' och 'Lösenord (igen)' är inte lika."
    end
  end

  def test_change_my_profile
    get :change_my_profile, {}, {:user_item_id => user_items(:test_user).id}
    assert_redirected_to @controller.url_for(:controller => '/browse', :action => :edit, :id => user_items(:test_user).spexare_item.id)
  end

  def test_change_my_profile_with_user_with_no_spexare_association
    get :change_my_profile, {}, {:user_item_id => user_items(:test_user_without_spexare).id}
    assert_redirected_to @controller.url_for(:action => :index)
    assert_equal 'Du är ej associerad med någon spexare.', flash[:error]
  end

  def test_about_open
    xhr :get, :about_open, {}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'aboutDialog'
  end
  
  def test_about_close
    xhr :get, :about_close, {}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
  end

  def test_in_case_of_problems_open
    xhr :get, :in_case_of_problems_open, {}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'problemDialog'
  end
  
  def test_in_case_of_problems_close
    xhr :get, :in_case_of_problems_close, {}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
  end
end
