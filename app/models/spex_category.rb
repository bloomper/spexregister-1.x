class SpexCategory < ActiveRecord::Base
  has_many :spex, :class_name => 'Spex'
  has_attached_file :logo, :styles => { :thumb => ApplicationConfig.logo_thumbnail_size }
  attr_protected :logo_file_name, :logo_content_type, :logo_file_size
  acts_as_dropdown :value => 'id', :text => 'name', :order => 'name ASC'
  
  def self.get_years
    Rails.cache.fetch('spex_category_years') { (ApplicationConfig.first_spex_category_year..Time.now.strftime('%Y').to_i).entries }
  end
  
  def self.update_years
    if self.get_years.max < Time.now.strftime('%Y').to_i
      Rails.cache.delete('spex_category_years')
      self.get_years
    end
  end
  
  def before_destroy
    if spex.size > 0
      errors.add(:base, I18n.t('spex_category.cannot_delete_if_associated_spex_exist'))
      false
    end
  end
  
  protected
  validates_presence_of :name
  validates_presence_of :first_year
  validates_uniqueness_of :name, :allow_blank => true
  validates_format_of :first_year, :with => /^(19|20|21)\d{2}$/, :allow_blank => true
  validates_attachment_content_type :logo, :content_type => ApplicationConfig.allowed_file_types.split(/,/), :if => Proc.new { |s| s.logo? } 
  validates_attachment_size :logo, :less_than => ApplicationConfig.max_upload_size.kilobytes, :if => Proc.new { |s| s.logo? }
  
end
