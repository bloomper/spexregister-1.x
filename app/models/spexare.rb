require 'attr_encrypted'

class Spexare < ActiveRecord::Base
  has_many :activities, :dependent => :destroy
  has_many :memberships, :dependent => :destroy
  has_one :relationship
  has_one :spouse, :through => :relationship
  has_one :user, :dependent => :nullify
  has_many :taggings, :dependent => :destroy
  has_attached_file :picture, :styles => { :thumb => ApplicationConfig.picture_thumbnail_size }
  attr_protected :picture_file_name, :picture_content_type, :picture_file_size
  attr_encrypted :social_security_number, :key => 'A8AD3BC66E66FC6C255312D70FFA547E1CE8FB8A4382BE961DFFBED0DD45B340', :encode => true
  attr_accessor_with_default :synchronize_spouse_address, false

  after_update :synchronize_address
  
  named_scope :by_spex, lambda { |spex_id|{
    :select => 'distinct spexare.*',
    :joins => 'left join activities on activities.spexare_id = spexare.id left join spex_activities on spex_activities.activity_id = activities.id left join spex on spex.id = spex_activities.spex_id',
    :conditions => ['spex.id = ?', spex_id] }
  }

  named_scope :by_spex_and_function, lambda { |spex_id, function_id|{
    :select => 'distinct spexare.*',
    :joins => 'left join activities on activities.spexare_id = spexare.id left join spex_activities on spex_activities.activity_id = activities.id left join spex on spex.id = spex_activities.spex_id left join function_activities on function_activities.activity_id = activities.id left join functions on functions.id = function_activities.function_id',
    :conditions => ['spex.id = ? and functions.id = ?', spex_id, function_id] }
  }

  def full_name
    [first_name, nick_name.blank? ? ' ' : " '#{nick_name}' ", last_name].join
  end

  def full_name_without_nickname
    [first_name, ' ', last_name].join
  end

  def editable_by
    user_group = UserGroup.find_by_name('Administrators')
    return self.user.nil? ? user_group.user_ids : user_group.user_ids | [self.user.id]
  end

  protected
  def synchronize_address
    if(synchronize_spouse_address == 'true' && !spouse.nil?)
      spouse.street_address = street_address
      spouse.postal_code = postal_code
      spouse.postal_address = postal_address
      spouse.country = country
      spouse.phone_home = phone_home
    end
  end

  validates_presence_of :last_name
  validates_presence_of :first_name
  validates_format_of :social_security_number, :with => /^\d{4}$/, :if => Proc.new { |s| !s.social_security_number.blank? }
  validates_attachment_content_type :picture, :content_type => ApplicationConfig.allowed_file_types.split(/,/), :if => Proc.new { |s| s.picture? } 
  validates_attachment_size :picture, :less_than => ApplicationConfig.max_upload_size.kilobytes, :if => Proc.new { |s| s.picture? }
  validates_as_email_address :email_address, :if => Proc.new { |s| !s.email_address.blank? }
  validates_date :birth_date, :allow_blank => true, :format => 'yyyy-mm-dd'
  
end
