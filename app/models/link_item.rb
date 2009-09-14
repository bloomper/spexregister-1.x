class LinkItem < ActiveRecord::Base
  belongs_to :spexare_item
  has_one :actor_item, :dependent => :destroy
  belongs_to :spex_item
  has_and_belongs_to_many :function_items

  acts_as_list :scope => :spexare_item_id
end
