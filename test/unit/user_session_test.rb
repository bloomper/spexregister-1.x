require 'test_helper'

class UserSessionTest < ActiveSupport::TestCase
  fixtures :users
  setup :activate_authlogic
  
  def test_ok
    user = users(:user)
    assert_nil controller.session["user_credentials"]
    assert UserSession.create(user)
    assert_equal controller.session["user_credentials"], user.persistence_token
  end

end