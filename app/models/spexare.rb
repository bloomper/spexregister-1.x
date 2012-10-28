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

  searchable do
    string :last_name #Needed for ordering
    text :last_name, :stored => true, :boost => 2.0
    string :first_name #Needed for ordering
    text :first_name, :stored => true, :boost => 2.0
    string :nick_name #Needed for ordering
    text :nick_name, :stored => true, :boost => 2.0
    text :street_address
    text :postal_code
    text :postal_address
    text :country
    text :phone_home
    text :phone_work
    text :phone_mobile
    text :phone_other
    text :email_address
    text :birth_date
    #text :social_security_number
    string :chalmers_student, :multiple => true do
      AVAILABLE_LOCALES.map { |locale| chalmers_student ? I18n.t('views.base.yes', :locale => locale[0]) : I18n.t('views.base.no', :locale => locale[0]) }
    end
    text :graduation
    text :comment
    string :deceased, :multiple => true do
      AVAILABLE_LOCALES.map { |locale| deceased ? I18n.t('views.base.yes', :locale => locale[0]) : I18n.t('views.base.no', :locale => locale[0]) }
    end
    string :publish_approval, :multiple => true do
      AVAILABLE_LOCALES.map { |locale| publish_approval ? I18n.t('views.base.yes', :locale => locale[0]) : I18n.t('views.base.no', :locale => locale[0]) }
    end
    string :want_circulars, :multiple => true do
      AVAILABLE_LOCALES.map { |locale| want_circulars ? I18n.t('views.base.yes', :locale => locale[0]) : I18n.t('views.base.no', :locale => locale[0]) }
    end
    string :want_email_circulars, :multiple => true do
      AVAILABLE_LOCALES.map { |locale| want_email_circulars ? I18n.t('views.base.yes', :locale => locale[0]) : I18n.t('views.base.no', :locale => locale[0]) }
    end
    text :fgv_memberships do
      memberships.by_kind(Membership.kind(:fgv).id).map { |membership| membership.year }
    end
    text :cing_memberships do
      memberships.by_kind(Membership.kind(:cing).id).map { |membership| membership.year }
    end
    text :taggings do
      taggings.map { |tagging| tagging.tag.name }
    end
    text :related_to do
      !spouse.blank? ? spouse.full_name_without_nickname : nil
    end
    text :spex_years do
      activities.map { |activity| activity.spex.year unless activity.spex.nil? }
    end
    text :spex_titles do
      activities.map { |activity| activity.spex.spex_detail.title unless activity.spex.nil? || activity.spex.spex_detail.nil? }
    end
    text :spex_categories do
      activities.map { |activity| activity.spex.spex_category.name unless activity.spex.nil? || activity.spex.spex_detail.nil? }
    end
    text :function_names do
      [].tap do |function_names|
        activities.each do |activity|
          activity.functions.each do |function|
            function_names << function.name unless function.nil?
          end
        end
      end
    end
    text :function_categories do
      [].tap do |function_categories|
        activities.each do |activity|
          activity.functions.each do |function|
            function_categories << function.function_category.name unless function.nil? || function.function_category.nil?
          end
        end
      end
    end
    text :actor_roles do
      [].tap do |actor_roles|
        activities.each do |activity|
          activity.actors.each do |actor|
            actor_roles << actor.role unless actor.nil?
          end
        end
      end
    end
    text :actor_vocals do
      [].tap do |actor_vocals|
        activities.each do |activity|
          activity.actors.each do |actor|
            actor_vocals << Actor.vocal(actor.vocal_id).title unless actor.nil? || actor.vocal_id.nil?
          end
        end
      end
    end
    time :created_at
    time :updated_at
    string :created_by do
      User.find_by_id(:created_by)
    end
    string :updated_by do
      User.find_by_id(:updated_by)
    end
    # Facets
    string :facet_spex_years, :multiple => true do
      activities.map { |activity| activity.spex.year unless activity.spex.nil? }
    end
    string :facet_spex_titles, :multiple => true do
      activities.map { |activity| activity.spex.spex_detail.title unless activity.spex.nil? || activity.spex.spex_detail.nil? }
    end
    string :facet_spex_categories, :multiple => true do
      activities.map { |activity| activity.spex.spex_category.name unless activity.spex.nil? || activity.spex.spex_detail.nil? }
    end
    string :facet_function_names, :multiple => true do
      [].tap do |function_names|
        activities.each do |activity|
          activity.functions.each do |function|
            function_names << function.name unless function.nil?
          end
        end
      end
    end
    string :facet_function_categories, :multiple => true do
      [].tap do |function_categories|
        activities.each do |activity|
          activity.functions.each do |function|
            function_categories << function.function_category.name unless function.nil? || function.function_category.nil?
          end
        end
      end
    end
  end

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
