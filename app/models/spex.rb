class Spex < ActiveRecord::Base
  belongs_to :spex_category
  has_one :spex_poster, :dependent => :destroy
  
end
