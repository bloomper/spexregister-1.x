class SpexCategory < ActiveRecord::Base
  has_many :spex, :class_name => 'Spex'
  has_attached_file :logo, :styles => { :thumb => ApplicationConfig.logo_thumbnail_size }
  attr_protected :logo_file_name, :logo_content_type, :logo_file_size
  acts_as_dropdown :value => 'id', :text => 'name', :order => 'name ASC'
  
  protected
  validates_presence_of :name
  validates_uniqueness_of :name, :allow_blank => true
  validates_attachment_content_type :logo, :content_type => ApplicationConfig.allowed_file_types.split(/,/), :if => Proc.new { |s| s.logo? } 
  validates_attachment_size :logo, :less_than => ApplicationConfig.max_upload_size.kilobytes, :if => Proc.new { |s| s.logo? }

end
