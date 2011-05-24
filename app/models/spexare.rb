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
    string :last_name
    string :efternamn, :using => :last_name
    string :first_name
    string :förnamn, :using => :first_name
    string :nick_name
    string :smeknamn, :using => :nick_name
    string :street_address
    string :gatuadress, :using => :street_address
    string :postal_code
    string :postkod, :using => :postal_code
    string :postal_address
    string :postadress, :using => :postal_address
    string :country
    string :land, :using => :country
    string :phone_home
    string :telefon_hem, :using => :phone_home
    string :phone_work
    string :telefon_arbete, :using => :phone_work
    string :phone_mobile
    string :telefon_mobil, :using => :phone_mobile
    string :phone_other
    string :telefon_annat, :using => :phone_other
    string :email_address
    string :emailadress, :using => :email_address
    date :birth_date
    date :födelsedatum, :using => :birth_date
    integer :social_security_number
    integer :personnummer, :using => :social_security_number
    boolean :chalmers_student
    boolean :chalmerist, :using => :chalmers_student
    string :graduation
    string :examen, :using => :graduation
    text :comment
    text :kommentar, :using => :comment
    string :deceased do
      deceased ? I18n.t('views.base.yes', :locale => 'en') : I18n.t('views.base.no', :locale => 'en')
    end
    string :avliden do
      deceased ? I18n.t('views.base.yes', :locale => 'sv-SE') : I18n.t('views.base.no', :locale => 'sv-SE')
    end
    string :publish_approval do
      publish_approval ? I18n.t('views.base.yes', :locale => 'en') : I18n.t('views.base.no', :locale => 'en')
    end
    string :tillåter_publicering do
      publish_approval ? I18n.t('views.base.yes', :locale => 'sv-SE') : I18n.t('views.base.no', :locale => 'sv-SE')
    end
    string :want_circulars do
      want_circulars ? I18n.t('views.base.yes', :locale => 'en') : I18n.t('views.base.no', :locale => 'en')
    end
    string :vill_ha_utskick do
      want_circulars ? I18n.t('views.base.yes', :locale => 'sv-SE') : I18n.t('views.base.no', :locale => 'sv-SE')
    end
    string :want_email_circulars do
      want_email_circulars ? I18n.t('views.base.yes', :locale => 'en') : I18n.t('views.base.no', :locale => 'en')
    end
    string :vill_ha_email_utskick do
      want_email_circulars ? I18n.t('views.base.yes', :locale => 'sv-SE') : I18n.t('views.base.no', :locale => 'sv-SE')
    end
    string :fgv_memberships, :multiple => true do
      memberships.by_kind(Membership.kind(:fgv).id).map { |membership| membership.year }
    end
    string :fgv_medlemsskap, :multiple => true do
      memberships.by_kind(Membership.kind(:fgv).id).map { |membership| membership.year }
    end
    string :cing_memberships, :multiple => true do
      memberships.by_kind(Membership.kind(:cing).id).map { |membership| membership.year }
    end
    string :cing_medlemsskap, :multiple => true do
      memberships.by_kind(Membership.kind(:cing).id).map { |membership| membership.year }
    end
    string :taggings, :multiple => true do
      taggings.map { |tagging| tagging.tag.name }
    end
    string :taggningar, :multiple => true do
      taggings.map { |tagging| tagging.tag.name }
    end
    string :related_to do
      !spouse.blank? ? spouse.full_name_without_nickname : nil
    end
    string :relaterad_till do
      !spouse.blank? ? spouse.full_name_without_nickname : nil
    end
    string :spex_years, :multiple => true do
      activities.map { |activity| activity.spex.year }
    end
    string :spex_titles, :multiple => true do
      activities.map { |activity| activity.spex.spex_detail.title }
    end
    string :spex_categories, :multiple => true do
      activities.map { |activity| activity.spex.spex_category.name }
    end
    string :function_names, :multiple => true do
      activities.map { |activity| activity.functions.map { |function| function.name } }
    end
    string :function_categories, :multiple => true do
      activities.map { |activity| activity.functions.map { |function| function.function_category.name } }
    end
    string :actor_roles, :multiple => true do
      activities.map { |activity| activity.actors.map { |actor| actor.role } }
    end
    string :actor_vocals, :multiple => true do
      activities.map { |activity| activity.actors.map { |actor| !actor.vocal.nil? ? Actor.vocal(actor.vocal_id).title : nil } }
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
