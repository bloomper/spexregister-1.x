class SpexPoster < ActiveRecord::Base
  belongs_to :spex
  has_attached_file :poster, :styles => { :thumb => "50x70" }
  
end
