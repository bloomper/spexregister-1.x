require File.dirname(__FILE__) + '/../test_helper'

class UserItemTest < Test::Unit::TestCase
  fixtures :user_items, :role_items, :spexare_items

  def test_validation_on_create
    spexare_item = spexare_items(:spexare_item_1)
    role_item = role_items(:test_role_user)
    user_item = UserItem.new(:user_name => nil, :user_password => nil, :user_password_confirmation => nil, :spexare_item => nil)
    assert !user_item.valid?, user_item.errors.full_messages
    assert user_item.errors.invalid?(:user_name), user_item.errors.full_messages
    # We get three errors on :user_name at this point
    assert user_item.errors.on(:user_name).include?("Du måste ange 'Användarnamn'.") 
    user_item.user_name = 'Te'
    assert !user_item.valid?, user_item.errors.full_messages
    assert user_item.errors.invalid?(:user_name), user_item.errors.full_messages
    # We get two errors on :user_name at this point
    assert user_item.errors.on(:user_name).include?("Angivet 'Användarnamn' får inte vara kortare än 3 tecken.") 
    user_item.user_name = 'Te¤%#'
    assert !user_item.valid?, user_item.errors.full_messages
    assert user_item.errors.invalid?(:user_name), user_item.errors.full_messages
    # We get one error on :user_name at this point
    assert user_item.errors.on(:user_name).include?("'Användarnamn' får endast bestå av följande tecken: a-z, A-Z, 0-9 och _") 
    user_item.user_name = 'TestUserName'
    assert !user_item.valid?, user_item.errors.full_messages
    assert user_item.errors.invalid?(:user_password), user_item.errors.full_messages
    # We get two errors on :user_password at this point
    assert user_item.errors.on(:user_password).include?("Angivet 'Lösenord' får inte vara kortare än 5 tecken.") 
    user_item.user_password = 'Te¤%#'
    assert !user_item.valid?, user_item.errors.full_messages
    assert user_item.errors.invalid?(:user_password), user_item.errors.full_messages
    # We get one error on :user_password at this point
    assert user_item.errors.on(:user_password).include?("'Lösenord' får endast bestå av följande tecken: a-z, A-Z, 0-9 och _") 
    user_item.user_password = 'TestUserPassword'
    assert !user_item.valid?, user_item.errors.full_messages
    assert user_item.errors.invalid?(:user_password_confirmation), user_item.errors.full_messages
    assert_equal "Du måste ange 'Lösenord (igen)'.", user_item.errors.on(:user_password_confirmation) 
    user_item.user_password_confirmation = 'TestUserPassword'
    assert !user_item.valid?, user_item.errors.full_messages
    assert user_item.errors.invalid?(:role_item), user_item.errors.full_messages
    assert_equal "Du måste ange 'Roll'.", user_item.errors.on(:role_item) 
    user_item.role_item = role_item
    assert !user_item.valid?, user_item.errors.full_messages
    assert user_item.errors.invalid?(:spexare_item), user_item.errors.full_messages
    assert_equal "Du måste ange en giltlig 'Spexare'.", user_item.errors.on(:spexare_item) 
    user_item.spexare_item = spexare_item
    assert user_item.valid?, user_item.errors.full_messages
    user_item.save

    another_user_item = UserItem.new(:user_name => 'TestUserName', :user_password => 'TestUserPassword', :user_password_confirmation => 'TestUserPassword', :spexare_item => spexare_item)
    another_user_item.role_item = role_item
    assert !another_user_item.valid?, another_user_item.errors.full_messages
    assert another_user_item.errors.invalid?(:user_name), another_user_item.errors.full_messages
    assert_equal "Angivet 'Användarnamn' existerar redan.", another_user_item.errors.on(:user_name) 
    another_user_item.user_name = 'TestUserName2'
    assert another_user_item.valid?, another_user_item.errors.full_messages

    another_user_item = UserItem.new(:user_name => 'TestUserName3', :user_password => 'TestUserPassword', :user_password_confirmation => 'TestUserPassword1', :spexare_item => spexare_item)
    another_user_item.role_item = role_item
    assert !another_user_item.valid?, another_user_item.errors.full_messages
    assert another_user_item.errors.invalid?(:user_password), another_user_item.errors.full_messages
    assert_equal "Angivna 'Lösenord' och 'Lösenord (igen)' är inte lika.", another_user_item.errors.on(:user_password) 
    another_user_item.user_password_confirmation = 'TestUserPassword'
    assert another_user_item.valid?, another_user_item.errors.full_messages
  end

  def test_spexare_item_full_name
    spexare_item = spexare_items(:spexare_item_1)
    role_item = role_items(:test_role_user)
    user_item = UserItem.new(:user_name => 'TestUserName', :user_password => 'TestUserPassword', :user_password_confirmation => 'TestUserPassword', :spexare_item => spexare_item)
    user_item.role_item = role_item
    assert_equal 'FirstName1 LastName1', user_item.spexare_item_full_name
  end
  
  def test_authentication
    spexare_item = spexare_items(:spexare_item_1)
    role_item = role_items(:test_role_user)
    user_item = UserItem.new(:user_name => 'TestUserName', :user_password => 'TestUserPassword', :user_password_confirmation => 'TestUserPassword', :spexare_item => spexare_item)
    user_item.role_item = role_item
    user_item.save
    assert_equal user_item, UserItem.authenticate('TestUserName', 'TestUserPassword')
    assert UserItem.authenticate?('TestUserName', 'TestUserPassword'), 'Could not authenticate user'
    assert !UserItem.authenticate?('TestUserName2', 'TestUserPassword2'), 'Could not authenticate user'
  end
  
  def test_is_in_role
    spexare_item = spexare_items(:spexare_item_1)
    role_item = role_items(:test_role_user)
    user_item = UserItem.new(:user_name => 'TestUserName', :user_password => 'TestUserPassword', :user_password_confirmation => 'TestUserPassword', :spexare_item => spexare_item)
    user_item.role_item = role_item
    user_item.save
    assert user_item.is_in_role?('USER'), 'Correct role was not accepted'
    assert !user_item.is_in_role?('ADMIN'), 'Incorrect role was accepted'
    assert !user_item.is_in_role?(nil), 'Nil role was accepted'
  end
  
  def test_user_password_encryption
    spexare_item = spexare_items(:spexare_item_1)
    role_item = role_items(:test_role_user)
    user_item = UserItem.new(:user_name => 'TestUserName', :user_password => 'TestUserPassword', :user_password_confirmation => 'TestUserPassword', :spexare_item => spexare_item)
    user_item.role_item = role_item
    assert_equal 'TestUserPassword', user_item.user_password
    user_item.save
    assert_not_equal 'TestUserPassword', user_item.user_password
    
    user_item.user_password = 'TestUserPassword2'
    user_item.user_password_confirmation = 'TestUserPassword2'
    assert_equal 'TestUserPassword2', user_item.user_password
    user_item.save
    assert_not_equal 'TestUserPassword2', user_item.user_password
    
    assert_equal '5d891e403bd6eb92cb464e15f4bf69478008fa62', UserItem.sha1('Test')
  end
  
  def test_delete_all_users
    spexare_item = spexare_items(:spexare_item_1)
    role_item = role_items(:test_role_user)
    user_item = UserItem.new(:user_name => 'TestUserName', :user_password => 'TestUserPassword', :user_password_confirmation => 'TestUserPassword', :spexare_item => spexare_item)
    user_item.role_item = role_item
    user_item.save
    begin
      user_item.destroy
    rescue Exception
      assert_equal 'Kan inte radera samtliga användare, minst en måste existera.', $!.to_s
    end
  end
end
