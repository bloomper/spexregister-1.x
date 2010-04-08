class Spex < ActiveRecord::Base
  acts_as_nested_set
  belongs_to :spex_category
  belongs_to :spex_detail
  accepts_nested_attributes_for :spex_detail
  before_destroy :destroy_spex_detail
  
  #  named_scope :by_category, lambda { |category, show_revivals|
  #    { :conditions => { :spex_category_id => category, :is_revival => show_revivals } }
  #  }
  #  named_scope :by_category_with_revivals, lambda { |category|
  #    { :conditions => { :spex_category_id => category } }
  #  }
  #  named_scope :by_ids, lambda { |ids|
  #    { :conditions => { :id => ids } }
  #  }
  #  named_scope :by_year, :order => 'year asc' 
  #  named_scope :by_year_desc, :order => 'year desc' 
  #  named_scope :by_title, :order => 'title asc' 
  #  named_scope :by_title_desc, :order => 'title desc' 

  def initialize(attributes=nil)
    super
    self.build_spex_detail unless self.spex_detail
  end
  
  def destroy_spex_detail
    if !is_revival?
      SpexDetail.destroy_all :id => spex_detail.id
    end
  end

  def get_years_til_now
   ((year.to_i + 1)..Time.now.strftime('%Y').to_i).entries
  end
  
  def revivals
    self.children
  end
  
  def is_revival?
    self.child?
  end
  
  def title
    spex_detail.title
  end
  
  def before_destroy
    if SpexActivity.spex_id_equals(id).all.size > 0
      errors.add(:base, I18n.t('spex.cannot_delete_if_associated_spexare_exist'))
      false
    end
  end
  
  protected
  def validate_uniqueness_on_create
    if !spex_category.nil? && !year.nil? && !spex_detail.title.nil?
      if Spex.find(:first, :joins => 'JOIN spex_details JOIN spex_categories', :conditions => ['spex_category_id = spex_categories.id AND spex.year = ? AND spex_details.title = ? AND spex_categories.id = ?', year, spex_detail.title, spex_category.id])
        errors.add_to_base(I18n.t('spex.invalid_combination'))
      end
    end
  end
  
  def validate_uniqueness_on_update
    if !spex_category.nil? && !year.nil? && !spex_detail.title.nil?
      if Spex.find(:first, :joins => 'JOIN spex_details JOIN spex_categories', :conditions => ['spex_category_id = spex_categories.id AND spex.year = ? AND spex_details.title = ? AND spex_categories.id = ? AND spex.id <> ?', year, spex_detail.title, spex_category.id, id])
        errors.add_to_base(I18n.t('spex.invalid_combination'))
      end
    end
  end
  
  validate_on_create :validate_uniqueness_on_create
  validate_on_update :validate_uniqueness_on_update
  validates_presence_of :year
  validates_format_of :year, :with => /^(19|20|21)\d{2}$/, :allow_blank => true
  validates_presence_of :spex_category
  
end
