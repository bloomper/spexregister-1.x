class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.logged_in_timeout = ApplicationConfig.logged_in_timeout
  end
  belongs_to :spexare
  has_and_belongs_to_many :user_groups
  include AASM
  aasm_column :state
  aasm_state :pending, :after_enter => :deliver_account_created_instructions!
  aasm_state :active, :after_enter => :deliver_account_approved_instructions!
  aasm_state :inactive
  aasm_state :rejected, :after_enter => :deliver_account_rejected_instructions!
  aasm_initial_state :pending
  
  aasm_event :approve do
    transitions :to => :active, :from => [:pending]
  end
  
  aasm_event :deactivate do
    transitions :to => :inactive, :from => [:active]
  end

  aasm_event :activate do
    transitions :to => :active, :from => [:inactive, :rejected]
  end

  aasm_event :reject do
    transitions :to => :rejected, :from => [:pending]
  end

  def active?
    ['active'].include? self.state
  end
  
  def approved?
    active?
  end

  def inactive?
    ['inactive'].include? self.state
  end

  def pending?
    ['pending'].include? self.state
  end

  def rejected?
    ['rejected'].include? self.state
  end

  protected
  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.deliver_password_reset_instructions(self.username)
  end
  
  def deliver_account_created_instructions!
    UserMailer.deliver_account_created_instructions(self.username)
  end
  
  def deliver_account_approved_instructions!
    UserMailer.deliver_account_approved_instructions(self.username)
  end
  
  def deliver_account_rejected_instructions!
    UserMailer.deliver_account_rejected_instructions(self.username)
  end

  def editable_by
    user_group = UserGroup.find_by_name('Administrators')
    if !self.nil?
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
  
  # Authlogic validates username, password and password_confirmation
  validates_presence_of :user_groups
  validates_as_email_address :username
  
end
