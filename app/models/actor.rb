class Actor < ActiveRecord::Base
  belongs_to :function_activity, :touch => true
  belongs_to_enum :vocal,
  { 1 => {:name => :unknown, :title => I18n.t('actor.vocal.unknown') },
    2 => {:name => :b1, :title => I18n.t('actor.vocal.b1')},
    3 => {:name => :b2, :title => I18n.t('actor.vocal.b2')},
    4 => {:name => :t1, :title => I18n.t('actor.vocal.t1')},
    5 => {:name => :t2, :title => I18n.t('actor.vocal.t2')},
    6 => {:name => :s1, :title => I18n.t('actor.vocal.s1')},
    7 => {:name => :s2, :title => I18n.t('actor.vocal.s2')},
    8 => {:name => :a1, :title => I18n.t('actor.vocal.a1')},
    9 => {:name => :a2, :title => I18n.t('actor.vocal.a2')}
  }
  
  protected
  validates_inclusion_of_enum :vocal_id, { :message => :inclusion, :allow_blank => true }
  
end
