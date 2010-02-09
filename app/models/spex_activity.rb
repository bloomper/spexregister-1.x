class SpexActivity < ActiveRecord::Base
  belongs_to :activity, :touch => true
  belongs_to :spex 

end
