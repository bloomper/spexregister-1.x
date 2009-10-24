class News < ActiveRecord::Base
  named_scope :latest, lambda { |*args| {:conditions => ["publication_date BETWEEN ? AND ?", (args[0]||2.weeks.ago).to_s(:short_format), (args[1]||Time.now).to_s(:short_format)]} }

  protected
  validates_presence_of :publication_date
  validates_date :publication_date
  validates_presence_of :subject
  validates_presence_of :body
  
end
