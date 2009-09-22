class Spexare < ActiveRecord::Base
  has_many :links, :order => :position, :dependent => :destroy, :after_remove => :update_index
  has_and_belongs_to_many :related_spexare, :class_name => 'Spexare', :join_table => 'related_spexare', :association_foreign_key => 'related_spexare_id', :foreign_key => 'spexare_id', :before_add => :validate_related_spexare, :after_add => :add_related_spexare_on_other_side
  belongs_to :user
  has_attached_file :picture, :styles => { :thumb => property(:picture_thumbnail_size) }
  attr_protected :related_spexare, :picture_file_name, :picture_content_type, :picture_file_size
  
  def add_related_spexare(related_spexare)
    self.related_spexare << related_spexare
  end
  
  def remove_related_spexare
    related_spexare[0].related_spexare.clear rescue nil
    related_spexare.clear rescue nil
  end
  
  def has_related_spexare?
    related_spexare.size > 0
  end
  
  protected
  def validate_related_spexare(related_spexare)
    puts "IN validate_related_spexare"
    # Note that it is required to use exceptions here as validation errors are not caught for associations 
    if related_spexare.size == 1
      raise I18n.t('spexare.only_one_relation_at_a_time')
    end
    if !related_spexare.nil? && related_spexare.related_spexare.size == 1
      raise I18n.t('spexare.related_spexare_already_has_a_relation') unless related_spexare.related_spexare.include?(self)
    end
  end
  
  def add_related_spexare_on_other_side(related_spexare)
    puts "IN add_related_spexare_on_other_side"
    related_spexare.related_spexare << self unless related_spexare.related_spexare.include?(self)
  end
  
  def validate_associated_records_for_related_spexare
    puts "IN validate_associated_records_for_related_spexare"
    # No implementation is needed but the method is required to exist
  end
  
  validate :validate_uniqueness_on_create
  validates_presence_of :last_name
  validates_presence_of :first_name
  validates_format_of :social_security_number, :with => /^\d{4}$/, :if => Proc.new { |s| !s.social_security_number.blank? }
  validates_attachment_content_type :picture, :content_type => property(:allowed_file_types).split(/,/), :if => Proc.new { |s| s.picture? } 
  validates_attachment_size :picture, :less_than => property(:max_upload_size).kilobytes, :if => Proc.new { |s| s.picture? }
  
end
