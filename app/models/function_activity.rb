class FunctionActivity < ActiveRecord::Base
  belongs_to :activity, :touch => true
  belongs_to :function 
  has_many :actors, :dependent => :destroy
  accepts_nested_attributes_for :actors, :allow_destroy => true, :reject_if => :all_blank
  
end
