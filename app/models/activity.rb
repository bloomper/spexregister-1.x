class Activity < ActiveRecord::Base
  belongs_to :spexare
  has_one :spex_activity
  has_one :spex, :through => :spex_activity
  has_many :function_activities
  has_many :functions, :through => :function_activities
  acts_as_list :scope => :spexare_id

end
