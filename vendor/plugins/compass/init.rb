if !(File.basename($0) == 'rake' && ARGV.include?('gems:install'))
  # This is here to make sure that the right version of sass gets loaded (haml 2.2) by the compass requires.
  require 'compass'
end