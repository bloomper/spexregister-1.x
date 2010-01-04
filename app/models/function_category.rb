class FunctionCategory < ActiveRecord::Base
  has_many :functions
  named_scope :by_name, :order => 'name asc' 
  named_scope :by_name_desc, :order => 'name desc' 
  acts_as_dropdown :value => 'id', :text => 'name', :order => 'name ASC'

  def before_destroy
    if functions.size > 0
      errors.add(:base, I18n.t('function_category.cannot_delete_if_associated_functions_exist'))
      false
    end
  end

  protected
  validates_presence_of :name
  validates_uniqueness_of :name, :allow_blank => true
  
end
