class FunctionAchievement < ActiveRecord::Base
  belongs_to :achievement
  belongs_to :function 
  has_one :actor, :dependent => :delete, :conditions => "function.category.has_actor = true"

end
