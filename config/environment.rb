# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.14' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.autoload_paths += %W( #{RAILS_ROOT}/extras )
  config.autoload_paths += %W( #{RAILS_ROOT}/app/mailers #{RAILS_ROOT}/app/utils #{RAILS_ROOT}/app/dashboard_reports #{RAILS_ROOT}/app/reports)

  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem 'sunspot_rails', :version => '2.0.0.pre.120720'
  config.gem 'erubis', :version => '2.7.0'
  config.gem 'haml', :version => '3.1.2'
  config.gem 'compass', :version => '0.11.1'
  config.gem 'hpricot', :version => '0.8.4'
  config.gem 'htmlentities', :version => '4.3.0'
  config.gem 'mysql', :version => '2.8.1'
  config.gem 'piston', :version => '2.0.10'
  config.gem 'rcov', :version => '0.8.1.2.0'
  config.gem 'encryptor', :version => '1.1.3'
  config.gem 'eigenclass', :version => '1.1.1'
  config.gem 'faraday', :version => '0.7.0'
  config.gem 'sqlite3-ruby', :lib => 'sqlite3', :version => '1.3.3'
  config.gem 'xml-simple', :lib => 'xmlsimple', :version => '1.0.15'
  config.gem 'libxml-ruby', :lib => 'libxml', :version => '2.0.5'
  config.gem 'BlueCloth', :lib => 'bluecloth', :version => '1.0.1'
  config.gem 'rdoc'

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Stockholm'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # Override to load from a nested structure, i.e. config/locales/**/*.rb,yml
  config.i18n.load_path += Dir[File.join(RAILS_ROOT, 'config', 'locales', '**', '*.{rb,yml}')]
  config.i18n.default_locale = 'sv-SE'

  config.active_record.colorize_logging = false
end

Haml::Template.options[:escape_html] = true
