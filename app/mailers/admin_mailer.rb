class AdminMailer < ActionMailer::Base
  
  def new_account_instructions(full_name, username, description)
    subject       I18n.t('mailers.subject_prefix') + ' ' + I18n.t('mailers.admin.new_account_instructions')
    from          ApplicationConfig.admin_email_address
    recipients    ApplicationConfig.admin_email_address
    sent_on       Time.now
    body          :full_name => full_name, :username => username, :description => description
  end
  
end
