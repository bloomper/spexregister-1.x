class SpexCategory < ActiveRecord::Base
  has_many :spex, :class_name => 'Spex'
  acts_as_dropdown :value => 'id', :text => 'name', :order => 'name ASC'
  
  protected
  validates_presence_of :name
  validates_uniqueness_of :name, :allow_blank => true
  
end
