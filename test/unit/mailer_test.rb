require File.dirname(__FILE__) + '/../test_helper'
require 'mailer'

class MailerTest < Test::Unit::TestCase

  def test_signup
    response = Mailer.create_signup('testemailaddress@test.se', 'TestName', 'TestUserName', 'TestDescription', ConfigurationItem.find_by_name(ConfigurationItem::ADMIN_MAIL_ADDRESS).value)
    assert_equal 'Meddelande från Chalmersspexets Adressregister', response.subject
    assert_equal ConfigurationItem.find_by_name(ConfigurationItem::ADMIN_MAIL_ADDRESS).value, response.to[0]
    assert_equal 'testemailaddress@test.se', response.from[0]
    assert_match /skulle vilja ha tillgång/, response.body
  end
end
