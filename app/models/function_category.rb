class FunctionCategory < ActiveRecord::Base
  has_many :functions
  acts_as_dropdown :value => 'id', :text => 'name', :order => 'name ASC'

  def before_destroy
    if functions.size > 0
      errors.add_to_base(I18n.t('function_category.cannot_delete_if_associated_functions_exist'))
      false
    end
  end

  protected
  validates_presence_of :name
  validates_uniqueness_of :name, :allow_blank => true
  
end
