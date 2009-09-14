class SpexareItem < ActiveRecord::Base
  DEFAULT_PAGE_SIZE = 10

  has_many :link_items, :order => :position, :dependent => :destroy, :after_remove => :update_index
  has_and_belongs_to_many :related_spexare_items, :class_name => 'SpexareItem', :join_table => 'related_spexare_items', :association_foreign_key => 'related_spexare_item_id', :foreign_key => 'spexare_item_id', :before_add => :validate_related_spexare, :after_add => :add_related_spexare_on_other_side
  attr_protected :related_spexare_items
  has_one :spexare_picture_item, :dependent => :destroy
  belongs_to :user_item
  acts_as_ferret :fields => {
    :efternamn => { :index => :yes, :boost => 2, :store => :yes, :ignore => true },
    :förnamn => { :index => :yes, :boost => 2, :store => :yes, :ignore => true },
    :smeknamn => { :index => :yes, :boost => 2, :store => :yes, :ignore => true },
    :gatuadress => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :postnummer => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :postadress => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :land => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :hemtelefon => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :arbetstelefon => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :mobiltelefon => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :annantelefon => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :emailadress => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :födelsedatum => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :personnummer => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :chalmerist => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :examen => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :kommentar => { :index => :yes, :boost => 1, :store => :no, :ignore => true },
    :avliden => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :publicering => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :utskick => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :fgvmedlem => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :cingmedlem => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :osäkeradress => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :relaterad => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :spexår => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :spextitel => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :spexkategori => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :funktionsnamn => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :funktionskategori => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :ensembleroll => { :index => :yes, :boost => 1, :store => :yes, :ignore => true },
    :ensemblestämma => { :index => :yes, :boost => 1, :store => :yes, :ignore => true }
  }, :store_class_name => true

  def add_related_spexare(related_spexare)
    related_spexare_items << related_spexare
  end

  def remove_related_spexare
    related_spexare_items[0].related_spexare_items.clear rescue nil
    related_spexare_items.clear rescue nil
  end

  def related_spexare_item_full_name
    related_spexare_items[0].full_name rescue nil
  end

  def related_spexare_item_full_name=(value)
  end
  
  def has_related_spexare?
    related_spexare_items.size > 0
  end

  def full_name
    if !nick_name.blank?
      return "#{first_name} '#{nick_name}' #{last_name}"
    else
      return "#{first_name} #{last_name}"
    end
  end

  def self.find_by_full_name(value, limit, exclude_this_id = nil)
    criteria = value.split(' ')
    if criteria.size > 1
      if exclude_this_id
        self.find(:all, :conditions => [ 'first_name LIKE ? AND last_name LIKE ? AND id != ?', "%#{criteria[0]}%", "%#{criteria[1]}%", exclude_this_id ], :order => 'first_name, last_name ASC', :limit => limit)
      else
        self.find(:all, :conditions => [ 'first_name LIKE ? AND last_name LIKE ?', "%#{criteria[0]}%", "%#{criteria[1]}%" ], :order => 'first_name, last_name ASC', :limit => limit)
      end
    else
      if exclude_this_id
        self.find(:all, :conditions => [ 'first_name LIKE ? AND id != ?', "%#{criteria[0]}%", exclude_this_id ], :order => 'first_name, last_name ASC', :limit => limit)
      else
        self.find(:all, :conditions => [ 'first_name LIKE ?', "%#{criteria[0]}%" ], :order => 'first_name, last_name ASC', :limit => limit)
      end
    end
  end

  def self.full_text_search(query, options = {})
    return nil if query.nil? or query == ''
    current = options[:current] && options[:current].to_i > 0 ? options[:current] : 1
    first = options[:first] || 1
    auto = options[:auto] || false
    count = SpexareItem.find_by_contents(query).total_hits
    limit = options.delete(:limit)
    total_size = limit ? [limit, count].min : count
    page_size = options[:size] || [total_size, DEFAULT_PAGE_SIZE].min
    PagingEnumerator.new(page_size, total_size, auto, current, first) do |page|
      options[:offset] = (page - 1) * page_size
      options[:limit] = (page_size) < total_size ? page_size : total_size
      SpexareItem.find_by_contents(query, options)
    end
  end
  
  def to_doc
    doc = super
    doc['efternamn'] = last_name
    doc['förnamn'] = first_name
    doc['smeknamn'] = nick_name unless nick_name.nil?
    doc['gatuadress'] = street_address unless street_address.nil?
    doc['postnummer'] = postal_code unless postal_code.nil?
    doc['postadress'] = postal_address unless postal_address.nil?
    doc['land'] = country unless country.nil?
    doc['hemtelefon'] = phone_home unless phone_home.nil?
    doc['arbetstelefon'] = phone_work unless phone_work.nil?
    doc['mobiltelefon'] = phone_mobile unless phone_mobile.nil?
    doc['annantelefon'] = phone_other unless phone_other.nil?
    doc['emailadress'] = email_address unless email_address.nil?
    doc['födelsedatum'] = birth_date unless birth_date.nil?
    doc['personnummer'] = social_security unless social_security.nil?
    if chalmers_student?
      doc['chalmerist'] = 'ja'
    else
      doc['chalmerist'] = 'nej'
    end
    doc['examen'] = graduation unless graduation.nil?
    doc['kommentar'] = comment unless comment.nil?
    if deceased?
      doc['avliden'] = 'ja'
    else
      doc['avliden'] = 'nej'
    end
    if publish_approval?
      doc['publicering'] = 'ja'
    else
      doc['publicering'] = 'nej'
    end
    if want_circulars?
      doc['utskick'] = 'ja'
    else
      doc['utskick'] = 'nej'
    end
    if fgv_member?
      doc['fgvmedlem'] = 'ja'
    else
      doc['fgvmedlem'] = 'nej'
    end
    if alumni_member?
      doc['cingmedlem'] = 'ja'
    else
      doc['cingmedlem'] = 'nej'
    end
    if uncertain_address?
      doc['osäkeradress'] = 'ja'
    else
      doc['osäkeradress'] = 'nej'
    end
    doc['relaterad'] = related_spexare_items[0].full_name unless related_spexare_items.empty?
    if !link_items.empty?
      spex_year_array = Array.new
      spex_title_array = Array.new
      spex_category_array = Array.new
      function_name_array = Array.new
      function_category_array = Array.new
      actor_role_array = Array.new
      actor_vocal_array = Array.new
      link_items.each do |link_item|
        spex_year_array << link_item.spex_item.year
        spex_title_array << link_item.spex_item.title
        spex_category_array << link_item.spex_item.spex_category_item.category_name
        link_item.function_items.each do |function_item|
          function_name_array << function_item.name
          function_category_array << function_item.function_category_item.category_name
          if function_item.function_category_item.has_actor? && !link_item.actor_item.nil?
            actor_role_array << link_item.actor_item.role unless link_item.actor_item.role.nil? || link_item.actor_item.role.empty?
            actor_vocal_array << link_item.actor_item.vocal unless link_item.actor_item.vocal.nil? || link_item.actor_item.vocal.empty?
          end
        end
      end
      doc['spexår'] = spex_year_array.join(' ')
      doc['spextitel'] = spex_title_array.join(' ')
      doc['spexkategori'] = spex_category_array.join(' ')
      doc['funktionsnamn'] = function_name_array.join(' ')
      doc['funktionskategori'] = function_category_array.join(' ')
      doc['ensembleroll'] = actor_role_array.join(' ')
      doc['ensemblestämma'] = actor_vocal_array.join(' ')
    end
    return doc
  end

  protected
    def update_index(link_item)
      ferret_update
    end

    def validate
      if !spexare_picture_item.nil?
        errors.add(:spexare_picture_item, "Storleken på '%{fn}' får inte överskrida 150 Kb.") if spexare_picture_item.size > 150.kilobytes
        errors.add(:spexare_picture_item, "'%{fn}' får endast vara av typerna PNG, JPG och GIF.") unless SpexarePictureItem.image?(spexare_picture_item.content_type)
        return
      end
    end
      
    def validate_related_spexare(related_spexare)
      # Note that it is required to use exceptions here as validation errors are not caught for associations 
      if related_spexare_items.size == 1
        raise 'Det går bara att ha en relation åt gången med en annan spexare.'
      end
      if !related_spexare.nil? && related_spexare.related_spexare_items.size == 1
        raise "Den angivna spexaren i 'Gift/sambo med' har redan en relation (kan endast ha en åt gången)." unless related_spexare.related_spexare_items.include?(self)
      end
    end

    def add_related_spexare_on_other_side(related_spexare)
      related_spexare.related_spexare_items << self unless related_spexare.related_spexare_items.include?(self)
    end

    def validate_associated_records_for_related_spexare_items
      # No implementation is needed but the method is required to exist
    end

    validates_presence_of :last_name, :message => N_("Du måste ange '%{fn}'.")
    validates_presence_of :first_name, :message => N_("Du måste ange '%{fn}'.")
    validates_format_of :social_security, :with => /^\d{4}$/, :message => N_("'%{fn}' måste innehålla fyra siffror."), :if => Proc.new { |model| !model.social_security.blank? }
    validates_associated :spexare_picture_item
end
