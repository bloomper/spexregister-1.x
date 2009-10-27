require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @password = Time.now.to_s
  end
  
  test "should be ok" do
    user = User.new(:username => "test@test.com", :password => @password, :password_confirmation => @password, :user_groups => [ user_groups(:admins_user_group) ], :spexare => spexare(:spexare_1))
    assert user.valid?, user.errors.full_messages.join("\n") 
  end
  
  test "should not save user with no username" do
    user = User.new(:username => nil, :password => @password, :password_confirmation => @password, :user_groups => [ user_groups(:admins_user_group) ], :spexare => spexare(:spexare_1))
    assert(!user.valid?, "Should not save entry unless username has been set")
    assert(user.errors.invalid?(:username), "Expected an error for missing username")
  end
  
  test "should not save user with no password" do
    user = User.new(:username => "test@test.com", :password => nil, :password_confirmation => nil, :user_groups => [ user_groups(:admins_user_group) ], :spexare => spexare(:spexare_1))
    assert(!user.valid?, "Should not save entry unless password has been set")
    assert(user.errors.invalid?(:password), "Expected an error for missing password")
  end
  
  test "should not save user with no user groups" do
    user = User.new(:username => "test@test.com", :password => @password, :password_confirmation => @password, :user_groups => [], :spexare => spexare(:spexare_1))
    assert(!user.valid?, "Should not save entry unless user groups have been set")
    assert(user.errors.invalid?(:user_groups), "Expected an error for missing user groups")
  end
  
  test "should not save user with invalid username" do
    user = User.new(:username => "1", :password => @password, :password_confirmation => @password, :user_groups => [ user_groups(:admins_user_group) ], :spexare => spexare(:spexare_1))
    assert(!user.valid?, "Should not save entry if an invalid username has been set")
    assert(user.errors.invalid?(:username), "Expected an error for invalid username")
    
    user = User.new(:username => "%¤&¤%", :password => @password, :password_confirmation => @password, :user_groups => [ user_groups(:admins_user_group) ], :spexare => spexare(:spexare_1))
    assert(!user.valid?, "Should not save entry if an invalid username has been set")
    assert(user.errors.invalid?(:username), "Expected an error for invalid username")

    user = User.new(:username => "@missingsomestuff", :password => @password, :password_confirmation => @password, :user_groups => [ user_groups(:admins_user_group) ], :spexare => spexare(:spexare_1))
    assert(!user.valid?, "Should not save entry if an invalid username has been set")
    assert(user.errors.invalid?(:username), "Expected an error for invalid username")
  end
  
  test "should not save user with invalid password" do
    user = User.new(:username => "test@test.com", :password => "1", :password_confirmation => "1", :user_groups => [ user_groups(:admins_user_group) ], :spexare => spexare(:spexare_1))
    assert(!user.valid?, "Should not save entry if an invalid password has been set")
    assert(user.errors.invalid?(:password), "Expected an error for invalid password")
    
    user = User.new(:username => "test@test.com", :password => @password, :password_confirmation => "1", :user_groups => [ user_groups(:admins_user_group) ], :spexare => spexare(:spexare_1))
    assert(!user.valid?, "Should not save entry if an invalid password has been set")
    assert(user.errors.invalid?(:password), "Expected an error for invalid password")
  end
  
  test "should not save user with already existing username" do
    existing_user = users(:user)
    user = User.new(:username => existing_user.username, :password => @password, :password_confirmation => @password, :user_groups => [ user_groups(:admins_user_group) ], :spexare => spexare(:spexare_1))
    assert(!user.valid?, "Should not save entry if username already exists")
    assert(user.errors.invalid?(:username), "Expected an error for duplicate username")
  end
  
  test "should not be able to delete all users" do
    begin
      users(:user).destroy
      users(:admin).destroy
    rescue Exception
      assert_equal I18n.t('user.cannot_delete_all_users'), $!.to_s
    end
  end
  
end
