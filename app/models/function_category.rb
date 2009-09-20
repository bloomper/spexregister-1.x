class FunctionCategory < ActiveRecord::Base
  has_many :functions
  acts_as_dropdown :value => 'id', :text => 'name', :order => 'name ASC'
  
  protected
  validates_presence_of :name
  validates_uniqueness_of :name
  
end
