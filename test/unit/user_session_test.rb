require 'test_helper'

class UserSessionTest < ActiveSupport::TestCase
  setup :activate_authlogic
  
  test "should be ok" do
    user = users(:user)
    assert_nil controller.session["user_credentials"]
    assert UserSession.create(user)
    assert_equal controller.session["user_credentials"], user.persistence_token
  end

end