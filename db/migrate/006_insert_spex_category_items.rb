class InsertSpexCategoryItems < ActiveRecord::Migration
  def self.up
    down
    
    SpexCategoryItem.create :category_name => 'Bob'
    SpexCategoryItem.create :category_name => 'Vera'
  end

  def self.down
    SpexCategoryItem.delete_all
  end
end
