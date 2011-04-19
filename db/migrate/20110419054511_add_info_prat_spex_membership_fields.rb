class AddInfoPratSpexMembershipFields < ActiveRecord::Migration
  def self.up
    add_column :spexare, :info_spex_member, :boolean, :default => false
    add_column :spexare, :prat_spex_member, :boolean, :default => false
  end

  def self.down
    remove_column :spexare, :info_spex_member
    remove_column :spexare, :prat_spex_member
  end
end
