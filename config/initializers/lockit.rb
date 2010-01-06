if !(File.basename($0) == 'rake' && ARGV.include?('db:migrate')) && !(File.basename($0) == 'runner')
  require 'lockdown'
  Lockdown.logger = Rails.logger
end
