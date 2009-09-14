class SpexCategoryItem < ActiveRecord::Base
  has_many :spex_items
  acts_as_dropdown :value => 'id', :text => 'category_name', :order => 'category_name ASC'
  
  protected
    validates_presence_of :category_name, :message => N_("Du måste ange '%{fn}'.")
    validates_uniqueness_of :category_name, :message => N_("Angivet '%{fn}' existerar redan.")
end
