require 'digest/sha1'

class User < ActiveRecord::Base
  belongs_to :role
  has_one :spexare, :dependent => :nullify
  attr_protected :role

end
