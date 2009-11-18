class Membership < ActiveRecord::Base
  belongs_to :spexare
  belongs_to_enum :kind,
  { 1 => {:name => :fgv, :title => I18n.t('membership.kind.fgv') },
    2 => {:name => :cing, :title => I18n.t('membership.kind.cing')}
  }
  named_scope :fgv_memberships, :conditions => {:kind_id => 1}
  named_scope :cing_memberships, :conditions => {:kind_id => 2}
  named_scope :by_kind, proc {|kind| { :conditions => { :kind_id => kind } } }

  def self.get_years(kind_type)
    if kind_type == self.kind(:fgv).id
      return self.get_fgv_years
    elsif kind_type == self.kind(:cing).id
      return self.get_cing_years
    else
      return nil
    end
  end

  def self.get_fgv_years
    Rails.cache.fetch('fgv_years') { (ApplicationConfig.first_fgv_year..Time.now.strftime('%Y').to_i).entries }
  end
  
  def self.update_fgv_years
    if self.get_fgv_years.max < Time.now.strftime('%Y').to_i
      Rails.cache.delete('fgv_years')
      self.get_fgv_years
    end
  end

  def self.get_cing_years
    Rails.cache.fetch('cing_years') { (ApplicationConfig.first_cing_year..Time.now.strftime('%Y').to_i).entries }
  end
  
  def self.update_cing_years
    if self.get_cing_years.max < Time.now.strftime('%Y').to_i
      Rails.cache.delete('cing_years')
      self.get_cing_years
    end
  end

  protected
  validates_inclusion_of_enum :kind_id, { :message => :inclusion, :allow_blank => false }
  validates_presence_of :year
  validates_format_of :year, :with => /^(19|20)\d{2}$/, :allow_blank => true

end
