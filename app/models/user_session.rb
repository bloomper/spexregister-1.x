class UserSession < Authlogic::Session::Base
  logout_on_timeout true
  generalize_credentials_error_messages true
  allow_http_basic_auth false
  remember_me_for ApplicationConfig.remember_me_for
  consecutive_failed_logins_limit ApplicationConfig.consecutive_failed_logins_limit
  failed_login_ban_for ApplicationConfig.failed_login_ban_for
  cookie_key '_spexregister_credentials'
  attr_accessor :session_id

  def before_create
    UserEvent.create(:user => self.user, :kind => UserEvent.kind(:login), :session_id => @session_id)
  end

  def before_destroy
    UserEvent.create(:user => self.user, :kind => UserEvent.kind(:logout), :session_id => @session_id)
  end

end