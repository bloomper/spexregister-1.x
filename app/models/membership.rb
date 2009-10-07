class Membership < ActiveRecord::Base
  belongs_to :spexare
  belongs_to_enum :kind,
  { 1 => {:name => :fgv, :title => I18n.t('membership.kind.fgv') },
    2 => {:name => :cing, :title => I18n.t('membership.kind.cing')}
  }
  
  protected
  validates_inclusion_of_enum :kind_id, { :message => :inclusion, :allow_blank => false }
  validates_presence_of :year
  validates_format_of :year, :with => /^(19|20)\d{2}$/

end
