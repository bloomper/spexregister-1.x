class News < ActiveRecord::Base
  has_markup :body, :required => true, :cache_html => true

  protected
  validates_presence_of :publication_date
  validates_date :publication_date, :format => 'yyyy-mm-dd'
  validates_presence_of :subject
  
end
