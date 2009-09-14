class InsertFunctionCategoryItems < ActiveRecord::Migration
  def self.up
    down
    
    FunctionCategoryItem.create :category_name => 'Kommitté'
    FunctionCategoryItem.create :category_name => 'Orkester'
    FunctionCategoryItem.create :category_name => 'Ensemble', :has_actor => true
    FunctionCategoryItem.create :category_name => 'Bandet'
    FunctionCategoryItem.create :category_name => 'Annat'
  end

  def self.down
    FunctionCategoryItem.delete_all
  end
end
