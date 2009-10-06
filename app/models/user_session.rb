class UserSession < Authlogic::Session::Base
  logout_on_timeout true
  generalize_credentials_error_messages true
  allow_http_basic_auth false
  remember_me_for ApplicationConfig.remember_me_for
  consecutive_failed_logins_limit ApplicationConfig.consecutive_failed_logins_limit
  failed_login_ban_for ApplicationConfig.failed_login_ban_for
end