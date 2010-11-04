class Spex < ActiveRecord::Base
  acts_as_nested_set
  belongs_to :spex_category
  belongs_to :spex_detail
  accepts_nested_attributes_for :spex_detail
  before_destroy :destroy_spex_detail
  
  named_scope :by_category, lambda { |category|
    { :conditions => ['spex.spex_category_id = ? AND spex.parent_id IS NULL', category] }
  }
  named_scope :revivals_by_category, lambda { |category|
    { :conditions => ['spex.spex_category_id = ? AND spex.parent_id IS NOT NULL', category] }
  }
  named_scope :by_ids, lambda { |ids|
    { :conditions => { :id => ids } }
  }
  named_scope :by_year, :order => 'year asc', :include => :spex_detail
  named_scope :by_year_desc, :order => 'year desc', :include => :spex_detail
  named_scope :by_title, :order => 'spex_details.title asc', :include => :spex_detail 
  named_scope :by_title_desc, :order => 'spex_details.title desc', :include => :spex_detail
  
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
  validates_presence_of :year
  validates_format_of :year, :with => /^(19|20|21)\d{2}$/, :allow_blank => true
  validates_presence_of :spex_category
  
end
