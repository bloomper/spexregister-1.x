class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.logged_in_timeout = property(:session_length).minutes.to_i
  end
  has_one :spexare, :dependent => :nullify
  belongs_to_enum :role,
  { 1 => {:name => :admin, :title => I18n.t('user.role.admin') },
    2 => {:name => :user, :title => I18n.t('user.role.user')}
  }
  attr_protected :role
  
  protected
  validates_inclusion_of_enum :role, { :message => :"inclusion", :allow_blank => false }
end
