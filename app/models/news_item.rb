class NewsItem < ActiveRecord::Base

  protected
    validates_presence_of :publication_date, :message => N_("Du måste ange '%{fn}'.")
    validates_presence_of :subject, :message => N_("Du måste ange '%{fn}'.")
    validates_presence_of :body, :message => N_("Du måste ange '%{fn}'.")
end
