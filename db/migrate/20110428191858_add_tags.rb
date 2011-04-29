class AddTags < ActiveRecord::Migration
  def self.up
    create_table :tags, :force => true do |t|
      t.column :name, :string
      t.integer :lock_version, :default => 0
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
    add_index :tags, :name, :unique => true

    create_table :taggings, :force => true do |t|
      t.integer :tag_id, :null => false
      t.integer :spexare_id, :null => false
      t.integer :lock_version, :default => 0
      t.string :created_by
      t.string :updated_by
      t.timestamps
      t.foreign_key :spexare_id, :spexare, :id
      t.foreign_key :tag_id, :tags, :id
    end
    add_index :taggings, :tag_id
    add_index :taggings, :spexare_id
  end

  def self.down
    drop_table :taggings
    drop_table :tags
  end
end
