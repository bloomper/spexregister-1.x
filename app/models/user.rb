class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.logged_in_timeout = ApplicationConfig.session_length.minutes.to_i
  end
  has_one :spexare, :dependent => :nullify
  has_and_belongs_to_many :user_groups
  attr_protected :role
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    # TODO: Implement me
    #Notifier.deliver_password_reset_instructions(self)
  end
  
end
