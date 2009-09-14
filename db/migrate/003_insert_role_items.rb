class InsertRoleItems < ActiveRecord::Migration
  def self.up
    down
    
    RoleItem.create :name => RoleItem::ADMIN, :description => 'Administratör'
    RoleItem.create :name => RoleItem::USER, :description => 'Användare'
  end

  def self.down
    RoleItem.delete_all
  end
end
