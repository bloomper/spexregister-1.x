class Achievement < ActiveRecord::Base
  belongs_to :spexare
  has_one :actor, :dependent => :destroy
  belongs_to :spex
  has_and_belongs_to_many :functions
  acts_as_list :scope => :spexare_id

end
