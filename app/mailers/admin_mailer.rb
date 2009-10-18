class AdminMailer < ActionMailer::Base
  
  def new_account_instructions(full_name, username, description)
    subject       I18n.t('views.base.title') + ': ' + I18n.t('views.base.new_account_instructions')
    from          ApplicationConfig.admin_mail_address
    recipients    ApplicationConfig.admin_mail_address
    sent_on       Time.now
    body          :full_name => full_name, :username => username, :description => description
  end
  
end
