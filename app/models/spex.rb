class Spex < ActiveRecord::Base
  belongs_to :spex_category
  has_attached_file :poster, :styles => { :thumb => ApplicationConfig.poster_thumbnail_size }
  attr_protected :poster_file_name, :poster_content_type, :poster_file_size

  def self.get_years
    Rails.cache.fetch('spex_years') { (ApplicationConfig.first_spex_year..Time.now.strftime('%Y').to_i).entries }
  end
  
  def self.update_years
    if self.get_years.max < Time.now.strftime('%Y').to_i
      Rails.cache.delete('spex_years')
      self.get_years
    end
  end
  
  protected
  def validate_uniqueness_on_create
    if !spex_category.nil? && !year.nil? && !title.nil?
      if Spex.find(:first, :joins => 'INNER JOIN spex_categories', :conditions => ['spex.spex_category_id = spex_categories.id AND spex.year = ? AND spex.title = ? AND spex.is_revival = ? AND spex_categories.id = ?', year, title, is_revival, spex_category.id])
        errors.add_to_base(I18n.t('spex.invalid_combination'))
      elsif Spex.find(:first, :joins => 'INNER JOIN spex_categories', :conditions => ['spex.spex_category_id = spex_categories.id AND spex.title = ? AND spex.is_revival = ? AND spex_categories.id = ?', title, is_revival, spex_category.id])
        errors.add_to_base(I18n.t('spex.combination_already_exists'))
      end
    end
  end
  
  def validate_uniqueness_on_update
    if !spex_category.nil? && !year.nil? && !title.nil?
      if Spex.find(:first, :joins => 'INNER JOIN spex_categories', :conditions => ['spex.spex_category_id = spex_categories.id AND spex.year = ? AND spex.title = ? AND spex.is_revival = ? AND spex_categories.id = ? AND spex.id <> ?', year, title, is_revival, spex_category.id, id])
        errors.add_to_base(I18n.t('spex.invalid_combination'))
      elsif Spex.find(:first, :joins => 'INNER JOIN spex_categories', :conditions => ['spex.spex_category_id = spex_categories.id AND spex.title = ? AND spex.is_revival = ? AND spex_categories.id = ? AND spex.id <> ?', title, is_revival, spex_category.id, id])
        errors.add_to_base(I18n.t('spex.combination_already_exists'))
      end
    end
  end
  
  validate_on_create :validate_uniqueness_on_create
  validate_on_update :validate_uniqueness_on_update
  validates_presence_of :year
  validates_presence_of :title
  validates_presence_of :spex_category
  validates_format_of :year, :with => /^(19|20)\d{2}$/, :allow_blank => true
  validates_attachment_content_type :poster, :content_type => ApplicationConfig.allowed_file_types.split(/,/), :if => Proc.new { |s| s.poster? } 
  validates_attachment_size :poster, :less_than => ApplicationConfig.max_upload_size.kilobytes, :if => Proc.new { |s| s.poster? }
  
end
