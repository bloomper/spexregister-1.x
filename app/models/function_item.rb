class FunctionItem < ActiveRecord::Base
  belongs_to :function_category_item
  acts_as_dropdown

  def name_with_category
    name + " (#{function_category_item.category_name})"
  end

  protected
    def validate_on_create
      # Need to check if function_category_item is nil as this callback is invoked before the built-in validators
      if function_category_item && FunctionItem.find(:first, :joins => 'INNER JOIN function_category_items', :conditions => ['function_items.function_category_item_id = function_category_items.id AND function_items.name = ? AND function_category_items.id = ?', name, function_category_item.id])
        errors.add_to_base('Kombinationen av namn och kategori används redan.')
        return
      end
    end
  
    def validate_on_update
      # Need to check if function_category_item is nil as this callback is invoked before the built-in validators
      if function_category_item && FunctionItem.find(:first, :joins => 'INNER JOIN function_category_items', :conditions => ['function_items.function_category_item_id = function_category_items.id AND function_items.name = ? AND function_category_items.id = ? AND function_items.id <> ?', name, function_category_item.id, id])
        errors.add_to_base('Kombinationen av namn och kategori används redan.')
        return
      end
    end

    validates_presence_of :name, :message => N_("Du måste ange '%{fn}'.")
    validates_presence_of :function_category_item, :message => N_("Du måste ange '%{fn}'.")
end
