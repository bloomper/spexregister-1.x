class RefactorRevivals < ActiveRecord::Migration
  def self.up
    create_table :spex_details, :force => true do |t|
      t.string :title, :null => false
      t.string :poster_file_name
      t.string :poster_content_type
      t.integer :poster_file_size
      t.datetime :poster_updated_at
      t.integer :lock_version, :default => 0
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
    add_index :spex_details, :title
    remove_index :spex, :title
    
    # TODO: Migrate existing data
    
    add_column :spex, :spex_detail_id, :integer, :default => 1, :null => false
    change_column :spex, :spex_detail_id, :integer, :default => nil
    add_foreign_key :spex, :spex_detail_id, :spex_details, :id
    add_column :spex, :parent_id, :integer
    add_column :spex, :lft, :integer
    add_column :spex, :rgt, :integer
    remove_column :spex, :title
    remove_column :spex, :is_revival
    remove_column :spex, :poster_file_name
    remove_column :spex, :poster_content_type
    remove_column :spex, :poster_file_size
    remove_column :spex, :poster_updated_at
    
    # Spex.rebuild!
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Can't recover from revival refactoring"
  end
end
