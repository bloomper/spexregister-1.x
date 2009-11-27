class FunctionActivity < ActiveRecord::Base
  belongs_to :activity
  belongs_to :function 
  has_one :actor, :dependent => :destroy
  accepts_nested_attributes_for :actor, :allow_destroy => true
  
  def initialize(attributes=nil)
    super
    self.build_actor unless self.actor
  end
  
end
