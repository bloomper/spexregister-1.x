class Achievement < ActiveRecord::Base
  belongs_to :spexare
  has_one :spex, :through => :spex_achievement
  has_many :functions, :through => :function_achievement
  acts_as_list :scope => :spexare_id

end
