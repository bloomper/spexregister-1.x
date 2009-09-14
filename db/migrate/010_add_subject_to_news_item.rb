class AddSubjectToNewsItem < ActiveRecord::Migration
  def self.up
    add_column :news_items, :subject, :string, :limit => 85, :null => false
  end

  def self.down
    remove_column :news_items, :subject
  end
end
