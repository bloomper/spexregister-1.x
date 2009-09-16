class SpexCategory < ActiveRecord::Base
  has_many :spex, :class_name => 'Spex'
  acts_as_dropdown :value => 'id', :text => 'category_name', :order => 'category_name ASC'
  
end
