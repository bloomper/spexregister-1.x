class FunctionActivity < ActiveRecord::Base
  belongs_to :activity
  belongs_to :function 
  has_one :actor, :dependent => :delete, :conditions => "function.category.has_actor = true"

end
