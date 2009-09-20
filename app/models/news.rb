class News < ActiveRecord::Base

  protected
  validates_presence_of :publication_date
  validates_presence_of :subject
  validates_presence_of :body
  
end
