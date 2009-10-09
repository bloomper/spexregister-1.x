class Cohabitant < ActiveRecord::Base
  belongs_to :spexare
  belongs_to :spexare_cohabitant, :class_name => 'Spexare', :foreign_key => 'spexare_id_cohabitant' 
  
  protected
  validates_presence_of :spexare
  validates_presence_of :spexare_cohabitant
  
end
