require 'application_config'

RAILS_ROOT = "#{File.dirname(__FILE__)}/.." unless defined?(RAILS_ROOT)
RAILS_ENV = (ENV['RAILS_ENV'] || 'production').dup unless defined?(RAILS_ENV)

class SessionCleaner
  def self.remove_stale_sessions
    ApplicationConfig.load
    CGI::Session::ActiveRecordStore::Session.destroy_all( ['updated_at < ?', Kernel.property(:session_length).minutes] ) 
  end
end
