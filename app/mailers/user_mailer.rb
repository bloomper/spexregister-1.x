class UserMailer < ActionMailer::Base
  default_url_options[:host] = ApplicationConfig.site_url
  
  def password_reset_instructions(email_address)
    subject       I18n.t('views.base.title') + ': ' + I18n.t('views.base.password_reset_instructions')
    from          ApplicationConfig.admin_mail_address
    recipients    email_address
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
  
  def account_created_instructions(email_address)
    subject       I18n.t('views.base.title') + ': ' + I18n.t('views.base.account_created_instructions')
    from          ApplicationConfig.admin_mail_address
    recipients    email_address
    sent_on       Time.now
    body          :login_url => login_url
  end
  
  def account_approved_instructions(email_address)
    subject       I18n.t('views.base.title') + ': ' + I18n.t('views.base.account_approved_instructions')
    from          ApplicationConfig.admin_mail_address
    recipients    email_address
    sent_on       Time.now
    body          :login_url => login_url
  end

  def account_rejected_instructions(email_address)
    subject       I18n.t('views.base.title') + ': ' + I18n.t('views.base.account_rejected_instructions')
    from          ApplicationConfig.admin_mail_address
    recipients    email_address
    sent_on       Time.now
  end

end
