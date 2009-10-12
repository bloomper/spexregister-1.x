class Achievement < ActiveRecord::Base
  belongs_to :spexare
  has_one :spex_achievement
  has_one :spex, :through => :spex_achievement
  has_many :function_achievements
  has_many :functions, :through => :function_achievements
  acts_as_list :scope => :spexare_id

end
