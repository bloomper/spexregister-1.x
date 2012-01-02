class AddUserEventsTable < ActiveRecord::Migration
  
  def self.up
    create_table :user_events, :force => true do |t|
      t.string :session_id
      t.integer :user_id
      t.integer :kind_id, :null => false
      t.integer :lock_version, :default => 0
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
    add_index :user_events, :user_id
    add_index :user_events, :kind_id
  end
  
  def self.down
    drop_table :user_events
  end
end
