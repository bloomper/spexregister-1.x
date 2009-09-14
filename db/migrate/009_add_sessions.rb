class AddSessions < ActiveRecord::Migration
  def self.up
    create_table :sessions, :force => true do |t|
      t.column :session_id, :string
      t.column :data, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    add_index :sessions, :session_id
    execute 'ALTER TABLE sessions ENGINE = MyISAM'
  end

  def self.down
    drop_table :sessions
  end
end
