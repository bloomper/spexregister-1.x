class DropUncertainAddressField < ActiveRecord::Migration
  def self.up
    remove_column :spexare, :uncertain_address
  end

  def self.down
    add_column :spexare, :uncertain_address, :boolean, :default => false
  end
end
