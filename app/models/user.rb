require 'digest/sha1'

class User < ActiveRecord::Base
  belongs_to :role
  has_one :spexare, :dependent => :nullify
  attr_protected :role
  
  @@salt = 'A8AD3BC66E66FC6C255312D70FFA547E1CE8FB8A4382BE961DFFBED0DD45B340'
  cattr_accessor :salt
  
  protected
  def self.sha1(pass)
    Digest::SHA1.hexdigest("#{salt}--#{pass}--")
  end
  
  validates_confirmation_of :password, :if => Proc.new { |u| u.password.size > 0}
  validates_presence_of :password_confirmation, :on => :create
  validates_presence_of :password_confirmation, :on => :update, :if => Proc.new { |u| !u.password.empty? && !u.password_confirmation.empty?}
end
