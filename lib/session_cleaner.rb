require 'settingslogic'

class SessionCleaner
  def self.remove_stale_sessions
    ApplicationConfig.new(:application_config)
    CGI::Session::ActiveRecordStore::Session.destroy_all( ['updated_at < ?', ApplicationConfig.session_length.minutes] ) 
  end
end
