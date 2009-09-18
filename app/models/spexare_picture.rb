class SpexarePicture < ActiveRecord::Base
  belongs_to :spexare
  has_attached_file :picture, :styles => { :thumb => "50x70" }
  
end
