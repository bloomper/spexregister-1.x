class RefactorRevivals < ActiveRecord::Migration
  class Spex < ActiveRecord::Base
    has_attached_file :poster, :styles => { :thumb => ApplicationConfig.poster_thumbnail_size }
  end

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
    
    add_column :spex, :spex_detail_id, :integer, :default => 1, :null => false
    change_column :spex, :spex_detail_id, :integer, :default => nil
    add_column :spex, :parent_id, :integer
    add_column :spex, :lft, :integer
    add_column :spex, :rgt, :integer
    Spex.reset_column_information

    Spex.all.each do |spex|
      remove_poster = true
      if !spex.is_revival
        spex_detail = SpexDetail.create(:title => spex.title, :created_by => spex.created_by, :updated_by => spex.updated_by, :created_at => spex.created_at, :updated_at => spex.updated_at, :lock_version => spex.lock_version)
        spex_detail.poster = spex.poster if spex.poster?
        spex.spex_detail_id = spex_detail.id
        spex_detail.save
        remove_poster = false if spex.id == spex_detail.id
      else
        original_spex = Spex.first :conditions => [ "title = ? AND is_revival = ?", spex.title, false]
        spex.parent_id = original_spex.id
        spex.spex_detail_id = original_spex.id
      end
      spex.poster = nil if spex.poster? && remove_poster
      spex.save
    end
    
    remove_column :spex, :title
    remove_column :spex, :is_revival
    remove_column :spex, :poster_file_name
    remove_column :spex, :poster_content_type
    remove_column :spex, :poster_file_size
    remove_column :spex, :poster_updated_at

    add_foreign_key :spex, :spex_detail_id, :spex_details, :id
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
