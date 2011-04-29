class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy

  protected
  validates_presence_of :name
  validates_uniqueness_of :name, :allow_blank => true
  
end
