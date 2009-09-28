class ApplicationConfig < Settingslogic
   source "#{Rails.root}/config/application_config.yml"
   namespace Rails.env
end