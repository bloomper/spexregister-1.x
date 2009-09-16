class Spexare < ActiveRecord::Base
  has_many :links, :order => :position, :dependent => :destroy, :after_remove => :update_index
  has_and_belongs_to_many :related_spexare, :class_name => 'Spexare', :join_table => 'related_spexare', :association_foreign_key => 'related_spexare_id', :foreign_key => 'spexare_id', :before_add => :validate_related_spexare, :after_add => :add_related_spexare_on_other_side
  attr_protected :related_spexare
  has_one :spexare_picture, :dependent => :destroy
  belongs_to :user

end
