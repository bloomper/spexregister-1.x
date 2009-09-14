class SpexItem < ActiveRecord::Base
  belongs_to :spex_category_item
  has_one :spex_poster_item, :dependent => :destroy
  acts_as_dropdown

  protected
    def validate_on_create
      # Need to check if spex_category_item is nil as this callback is invoked before the built-in validators
      if spex_category_item && SpexItem.find(:first, :joins => 'INNER JOIN spex_category_items', :conditions => ['spex_items.spex_category_item_id = spex_category_items.id AND spex_items.year = ? AND spex_items.title = ? AND spex_category_items.id = ?', year, title, spex_category_item.id])
        errors.add_to_base('Kombinationen av år, titel och kategori används redan.')
        return
      end
      if spex_category_item && SpexItem.find(:first, :joins => 'INNER JOIN spex_category_items', :conditions => ['spex_items.spex_category_item_id = spex_category_items.id AND spex_items.title = ? AND spex_category_items.id = ?', title, spex_category_item.id])
        errors.add_to_base('Det finns redan ett spex med angivna titeln och kategorin.')
        return
      end
    end
  
    def validate_on_update
      # Need to check if spex_category_item is nil as this callback is invoked before the built-in validators
      if spex_category_item && SpexItem.find(:first, :joins => 'INNER JOIN spex_category_items', :conditions => ['spex_items.spex_category_item_id = spex_category_items.id AND spex_items.year = ? AND spex_items.title = ? AND spex_category_items.id = ? AND spex_items.id <> ?', year, title, spex_category_item.id, id])
        errors.add_to_base('Kombinationen av år, titel och kategori används redan.')
        return
      end
      if spex_category_item && SpexItem.find(:first, :joins => 'INNER JOIN spex_category_items', :conditions => ['spex_items.spex_category_item_id = spex_category_items.id AND spex_items.title = ? AND spex_category_items.id = ? AND spex_items.id <> ?', title, spex_category_item.id, id])
        errors.add_to_base('Det finns redan ett spex med angivna titeln och kategorin.')
        return
      end
    end
    
    def validate
      if !spex_poster_item.nil?
        errors.add(:spex_poster_item, "Storleken på '%{fn}' får inte överskrida 150 Kb.") if spex_poster_item.size > 150.kilobytes
        errors.add(:spex_poster_item, "'%{fn}' får endast vara av typerna PNG, JPG och GIF.") unless SpexPosterItem.image?(spex_poster_item.content_type)
        return
      end
    end

    validates_presence_of :year, :message => N_("Du måste ange '%{fn}'.")
    validates_presence_of :title, :message => N_("Du måste ange '%{fn}'.")
    validates_presence_of :spex_category_item, :message => N_("Du måste ange '%{fn}'.")
    validates_format_of :year, :with => /^(19|20)\d{2}$/, :message => N_("'%{fn}' måste vara ett giltligt årtal.")
    validates_associated :spex_poster_item
end
