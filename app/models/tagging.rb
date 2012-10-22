class Tagging < ActiveRecord::Base
  belongs_to :spexare
  belongs_to :tag

  protected
  validates_presence_of :tag_id
  validates_presence_of :spexare_id
  
end
