class SpexDetail < ActiveRecord::Base
  has_attached_file :poster, :styles => { :thumb => ApplicationConfig.poster_thumbnail_size }
  attr_protected :poster_file_name, :poster_content_type, :poster_file_size

  protected
  validates_presence_of :title
  validates_attachment_content_type :poster, :content_type => ApplicationConfig.allowed_file_types.split(/,/), :if => Proc.new { |s| s.poster? } 
  validates_attachment_size :poster, :less_than => ApplicationConfig.max_upload_size.kilobytes, :if => Proc.new { |s| s.poster? }
  
end
