class SpexCategory < ActiveRecord::Base
  has_many :spex, :class_name => 'Spex'
  acts_as_dropdown :value => 'id', :text => 'name', :order => 'name ASC'
  
end
