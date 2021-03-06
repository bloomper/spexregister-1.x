class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.logged_in_timeout = ApplicationConfig.logged_in_timeout
  end
  belongs_to :spexare
  has_and_belongs_to_many :user_groups
  include AASM
  aasm_column :state
  # Note: initial state cannot send mail as it does not commit to the database (using queued mails)
  aasm_state :pending
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
  
  def spexare_full_name
    spexare.full_name unless spexare.nil?
  end
  
  def spexare_full_name=(value)
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.deliver_password_reset_instructions!(self.username, self.perishable_token)
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

  protected
  def editable_by
    user_group = UserGroup.find_by_name('Administrators')
    if !self.nil?
      user_group.user_ids |= [self.id]
    else
      user_group.user_ids
    end
  end
  
  def before_destroy
    # Keeping events for now
    #UserEvent.destroy_all(:user_id => self.id)
  end

  def after_destroy
    if User.count.zero?
      raise I18n.t('user.cannot_delete_all_users')
    end
  end
  
  # Authlogic validates username, password and password_confirmation
  validates_presence_of :user_groups
  validates_as_email_address :username
  validates_presence_of :spexare, :unless => Proc.new { |u| u.pending? }
  validates_uniqueness_of :spexare_id, :allow_nil => true

end
