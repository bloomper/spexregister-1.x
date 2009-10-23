class News < ActiveRecord::Base
  named_scope :latest, lambda { |*args| {:conditions => ["publication_date > ?", (args.first || 2.weeks.ago)]} }

  protected
  validates_presence_of :publication_date
  validates_date :publication_date
  validates_presence_of :subject
  validates_presence_of :body
  
end
