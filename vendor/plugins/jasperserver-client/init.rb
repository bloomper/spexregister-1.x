if !(File.basename($0) == 'rake' && ARGV.include?('gems:install'))
  # This file makes it possible to install JasperServer-Client as a Rails plugin.
  
  $: << File.expand_path(File.dirname(__FILE__))+'/lib'
  
  require 'jasperserver-client'
end