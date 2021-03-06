class Function < ActiveRecord::Base
  belongs_to :function_category
  named_scope :by_category, lambda { |category_id|
    { :conditions => { :function_category_id => category_id } }
  }
  named_scope :by_name, :order => 'name asc' 
  named_scope :by_name_desc, :order => 'name desc' 
  acts_as_dropdown
  
  def name_with_category
    name + " (#{function_category.name})"
  end

  def before_destroy
    if FunctionActivity.function_id_equals(id).all.size > 0
      errors.add(:base, I18n.t('function.cannot_delete_if_associated_spexare_exist'))
      false
    end
  end

  protected
  def validate_uniqueness_on_create
    if !function_category.nil? && !name.nil? && Function.find(:first, :joins => 'INNER JOIN function_categories', :conditions => ['functions.function_category_id = function_categories.id AND functions.name = ? AND function_categories.id = ?', name, function_category.id])
      errors.add_to_base(I18n.t('function.invalid_combination'))
    end
  end
  
  def validate_uniqueness_on_update
    if !function_category.nil? && !name.nil? && Function.find(:first, :joins => 'INNER JOIN function_categories', :conditions => ['functions.function_category_id = function_categories.id AND functions.name = ? AND function_categories.id = ? AND functions.id <> ?', name, function_category.id, id])
      errors.add_to_base(I18n.t('function.invalid_combination'))
    end
  end
  
  validate_on_create :validate_uniqueness_on_create
  validate_on_update :validate_uniqueness_on_update
  validates_presence_of :name
  validates_presence_of :function_category
end
