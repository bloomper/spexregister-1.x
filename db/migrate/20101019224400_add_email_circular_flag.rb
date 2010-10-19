class AddEmailCircularFlag < ActiveRecord::Migration
  
  def self.up
    add_column :spexare, :want_email_circulars, :boolean, :default => false
  end
  
  def self.down
    remove_column :spexare, :want_email_circulars
  end
end
