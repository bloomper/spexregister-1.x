require 'digest/sha1'

class UserItem < ActiveRecord::Base
  belongs_to :role_item
  has_one :spexare_item, :dependent => :nullify
  attr_protected :role_item

  @@salt = 'A8AD3BC66E66FC6C255312D70FFA547E1CE8FB8A4382BE961DFFBED0DD45B340'
  cattr_accessor :salt

  def spexare_item_full_name
    spexare_item.full_name rescue nil
  end

  def spexare_item_full_name=(value)
  end

  def self.authenticate(user_name, user_password)
    find(:first, :conditions => ['user_name = ? AND user_password = ?', user_name, sha1(user_password)])
  end

  def self.authenticate?(user_name, user_password)
    user = self.authenticate(user_name, user_password)
    return false if user.nil?
    return true if user.user_name == user_name
    
    false
  end

  def user_password=(new_user_password)
    @user_password = new_user_password
  end

  def user_password(cleartext = nil)
    if cleartext
      @user_password.to_s
    else
      @user_password || read_attribute('user_password')
    end
  end

  def is_in_role?(role)
    if role.nil?
      return false;
    end
    return role_item.name == role
  end

  protected
    def self.sha1(pass)
      Digest::SHA1.hexdigest("#{salt}--#{pass}--")
    end
  
    before_create :crypt_user_password
  
    def crypt_user_password
      write_attribute 'user_password', self.class.sha1(user_password(true))
      @user_password = nil
    end
  
    before_update :crypt_user_password_unless_empty
  
    def crypt_user_password_unless_empty
      if user_password(true).empty?      
        user = self.class.find(self.id)
        self.user_password = user.user_password
      else
        write_attribute 'user_password', self.class.sha1(user_password(true))
        @user_password = nil
      end
    end
    
    def after_destroy
      if UserItem.count.zero?
        raise 'Kan inte radera samtliga användare, minst en måste existera.'
      end
    end
  
    validates_uniqueness_of :user_name, :message => N_("Angivet '%{fn}' existerar redan.")
    validates_confirmation_of :user_password, :if => Proc.new { |u| u.user_password.size > 0}, :message => N_("Angivna '%{fn}' och '%{fn} (igen)' är inte lika.")
    validates_length_of :user_name, :minimum => 3, :too_short => N_("Angivet '%{fn}' får inte vara kortare än 3 tecken.")
    validates_length_of :user_password, :minimum => 5, :too_short => N_("Angivet '%{fn}' får inte vara kortare än 5 tecken."), :on => :create
    validates_length_of :user_password, :minimum => 5, :too_short => N_("Angivet '%{fn}' får inte vara kortare än 5 tecken."), :on => :update, :if => Proc.new { |u| !u.user_password.empty? && !u.user_password_confirmation.empty?}
    validates_presence_of :spexare_item, :message => N_("Du måste ange en giltlig '%{fn}'.")
    validates_presence_of :user_name, :message => N_("Du måste ange '%{fn}'.")
    validates_presence_of :role_item, :message => N_("Du måste ange '%{fn}'.")
    validates_presence_of :user_password, :message => N_("Du måste ange '%{fn}'."), :on => :create
    validates_presence_of :user_password, :message => N_("Du måste ange '%{fn}'."), :on => :update, :if => Proc.new { |u| !u.user_password.empty? && !u.user_password_confirmation.empty?}
    validates_presence_of :user_password_confirmation, :message => N_("Du måste ange '%{fn}'."), :on => :create
    validates_presence_of :user_password_confirmation, :message => N_("Du måste ange '%{fn}'."), :on => :update, :if => Proc.new { |u| !u.user_password.empty? && !u.user_password_confirmation.empty?}
    validates_format_of :user_name, :with => /^[a-zA-Z0-9_]+$/, :message => N_("'%{fn}' får endast bestå av följande tecken: a-z, A-Z, 0-9 och _")
    validates_format_of :user_password, :with => /^[a-zA-Z0-9_]+$/, :message => N_("'%{fn}' får endast bestå av följande tecken: a-z, A-Z, 0-9 och _"), :on => :create
    validates_format_of :user_password, :with => /^[a-zA-Z0-9_]+$/, :message => N_("'%{fn}' får endast bestå av följande tecken: a-z, A-Z, 0-9 och _"), :on => :update, :if => Proc.new { |u| !u.user_password.empty? && !u.user_password_confirmation.empty?}
end
