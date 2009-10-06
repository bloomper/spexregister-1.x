class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.logged_in_timeout = ApplicationConfig.logged_in_timeout
  end
  has_one :spexare, :dependent => :nullify
  has_and_belongs_to_many :user_groups
  
  def after_destroy
    if User.count.zero?
      raise I18n.t('user.cannot_delete_all_users')
    end
  end
  
  validates_presence_of :spexare
  validates_presence_of :user_groups
  
end
