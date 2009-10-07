require 'attr_encrypted'

class Spexare < ActiveRecord::Base
  has_many :links, :order => :position, :dependent => :destroy
  #, :after_remove => :update_index
  has_many :fgv_memberships, :class_name => 'Membership', :order => :year, :dependent => :destroy
  has_many :cing_memberships, :class_name => 'Membership', :order => :year, :dependent => :destroy
  acts_as_network :cohabitants, :join_table => :cohabitants, :foreign_key => 'spexare_id', :association_foreign_key => 'spexare_id_cohabitant'
  belongs_to :user
  has_attached_file :picture, :styles => { :thumb => ApplicationConfig.picture_thumbnail_size }
  attr_protected :picture_file_name, :picture_content_type, :picture_file_size
  attr_encrypted :social_security_number, :key => 'A8AD3BC66E66FC6C255312D70FFA547E1CE8FB8A4382BE961DFFBED0DD45B340', :encode => true
  validates_as_email_address :email_address

  protected
  validates_presence_of :last_name
  validates_presence_of :first_name
  validates_format_of :social_security_number, :with => /^\d{4}$/, :if => Proc.new { |s| !s.social_security_number.blank? }
  validates_attachment_content_type :picture, :content_type => ApplicationConfig.allowed_file_types.split(/,/), :if => Proc.new { |s| s.picture? } 
  validates_attachment_size :picture, :less_than => ApplicationConfig.max_upload_size.kilobytes, :if => Proc.new { |s| s.picture? }
  
end
