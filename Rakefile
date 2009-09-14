# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

# This line must be commented in order get 'rake doc:app' working
#require 'gettext/utils'

desc 'Create mo-files for L10n'
task :makemo do
  GetText.create_mofiles(true, 'po', 'locale')
end

desc 'Update pot/po files to match new version.'
task :updatepo do
  SPEXREGISTER_TEXT_DOMAIN = 'spexregister'
  SPEXREGISTER_VERSION     = 'spexregister'
  GetText.update_pofiles(SPEXREGISTER_TEXT_DOMAIN, 
                         Dir.glob('{app,lib}/**/*.{rb,rhtml,rjs,rxml}'), 
                         SPEXREGISTER_VERSION)
end

# Redefinition of the rdoc task to force UTF-8 character encoding
# Note that this causes the task to be run twice as it is also defined in tasks/rails, found no workaround for this
namespace :doc do
  desc "Generate documentation for the application" 
  Rake::RDocTask.new("app") { |rdoc| 
    rdoc.rdoc_dir = 'doc/app' 
    rdoc.title    = "Chalmersspexets Adressregister" 
    rdoc.options << '--line-numbers' << '--inline-source' << '--charset=utf-8' 
    rdoc.rdoc_files.include('doc/README_FOR_APP') 
    rdoc.rdoc_files.include('app/**/*.rb') 
  }
end
