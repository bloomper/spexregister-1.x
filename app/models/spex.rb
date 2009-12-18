class Spex < ActiveRecord::Base
  belongs_to :spex_category
  has_attached_file :poster, :styles => { :thumb => ApplicationConfig.poster_thumbnail_size }
  attr_protected :poster_file_name, :poster_content_type, :poster_file_size
  named_scope :by_category, lambda { |category, show_revivals|
    { :conditions => { :spex_category_id => category, :is_revival => show_revivals } }
  }
  named_scope :by_years, lambda { |years|
    { :conditions => { :year => years } }
  }
  named_scope :by_year, :order => 'year asc' 
  named_scope :by_year_desc, :order => 'year desc' 
  named_scope :by_title, :order => 'title asc' 
  named_scope :by_title_desc, :order => 'title desc' 

  def year_with_revival
    [year, (is_revival ? I18n.t('spex.with_revival') : nil)].join(' ')
  end

  def title_with_revival
    [title, (is_revival ? I18n.t('spex.with_revival') : nil)].join(' ')
  end
  
  def before_destroy
    if SpexActivity.spex_id_equals(id).all.size > 0
      errors.add_to_base(I18n.t('spex.cannot_delete_if_associated_spexare_exist'))
      false
    end
  end

  protected
  def validate_uniqueness_on_create
    if !spex_category.nil? && !year.nil? && !title.nil?
      if Spex.find(:first, :joins => 'INNER JOIN spex_categories', :conditions => ['spex.spex_category_id = spex_categories.id AND spex.year = ? AND spex.title = ? AND spex.is_revival = ? AND spex_categories.id = ?', year, title, is_revival, spex_category.id])
        errors.add_to_base(I18n.t('spex.invalid_combination'))
      end
    end
  end
  
  def validate_uniqueness_on_update
    if !spex_category.nil? && !year.nil? && !title.nil?
      if Spex.find(:first, :joins => 'INNER JOIN spex_categories', :conditions => ['spex.spex_category_id = spex_categories.id AND spex.year = ? AND spex.title = ? AND spex.is_revival = ? AND spex_categories.id = ? AND spex.id <> ?', year, title, is_revival, spex_category.id, id])
        errors.add_to_base(I18n.t('spex.invalid_combination'))
      end
    end
  end
  
  validate_on_create :validate_uniqueness_on_create
  validate_on_update :validate_uniqueness_on_update
  validates_presence_of :year
  validates_presence_of :title
  validates_presence_of :spex_category
  validates_format_of :year, :with => /^(19|20|21)\d{2}$/, :allow_blank => true
  validates_attachment_content_type :poster, :content_type => ApplicationConfig.allowed_file_types.split(/,/), :if => Proc.new { |s| s.poster? } 
  validates_attachment_size :poster, :less_than => ApplicationConfig.max_upload_size.kilobytes, :if => Proc.new { |s| s.poster? }
  
end
