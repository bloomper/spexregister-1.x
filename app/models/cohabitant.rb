class Cohabitant < ActiveRecord::Base
  belongs_to :spexare
  belongs_to :spexare_target, :class_name => 'Spexare', :foreign_key => 'spexare_id_target' 
  
  protected
  validates_presence_of :spexare
  validates_presence_of :spexare_target
  
end
