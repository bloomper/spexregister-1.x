class InsertUserItems < ActiveRecord::Migration
  def self.up
    down
    
    user = UserItem.new :user_name => 'admin', :user_password => 'admin99', :user_password_confirmation => 'admin99'
    user.role_item = RoleItem.find_by_name(RoleItem::ADMIN)
    user.create
    user = UserItem.new :user_name => 'user', :user_password => 'user99', :user_password_confirmation => 'user99'
    user.role_item = RoleItem.find_by_name(RoleItem::USER)
    user.create
  end

  def self.down
    UserItem.delete_all
  end
end
