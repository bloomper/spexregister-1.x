class RoleItem < ActiveRecord::Base
  ADMIN = 'ADMIN'
  USER = 'USER'

  acts_as_dropdown :value => 'id', :text => 'description', :order => 'description ASC'
  
  protected
    validates_presence_of :name, :message => N_("Du måste ange '%{fn}'.")
    validates_uniqueness_of :name, :message => N_("Angivet '%{fn}' existerar redan.")
    validates_presence_of :description, :message => N_("Du måste ange '%{fn}'.")
    validates_uniqueness_of :description, :message => N_("Angiven '%{fn}' existerar redan.")
end
