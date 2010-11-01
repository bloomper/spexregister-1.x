class UserEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to_enum :kind,
  { 1 => {:name => :login, :title => I18n.t('user_event.kind.login') },
    2 => {:name => :logout, :title => I18n.t('user_event.kind.logout')}
  }

end
