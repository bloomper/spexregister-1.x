class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.logged_in_timeout = ApplicationConfig.logged_in_timeout
  end
  has_one :spexare, :dependent => :nullify
  has_and_belongs_to_many :user_groups
  
  protected
  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.deliver_password_reset_instructions(self)
  end

  def editable_by
    user_group = UserGroup.find_by_name('Administrators')
    if !self.user.nil?
      user_group.user_ids |= [self.id]
    else
      user_group.user_ids
    end
  end
  
  def after_destroy
    if User.count.zero?
      raise I18n.t('user.cannot_delete_all_users')
    end
  end
  
  validates_presence_of :spexare
  validates_presence_of :user_groups
  
end
