class UserMailer < ActionMailer::Base
  default_url_options[:host] = Settings['general.site_url']
  
  def password_reset_instructions(email_address, perishable_token)
    subject       I18n.t('mailers.subject_prefix') + ' ' + I18n.t('mailers.user.password_reset_instructions')
    from          Settings['general.admin_email_address']
    recipients    email_address
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(perishable_token)
  end
  
  def account_created_instructions(email_address)
    subject       I18n.t('mailers.subject_prefix') + ' ' + I18n.t('mailers.user.account_created_instructions')
    from          Settings['general.admin_email_address']
    recipients    email_address
    sent_on       Time.now
    body          :login_url => login_url
  end
  
  def account_approved_instructions(email_address)
    subject       I18n.t('mailers.subject_prefix') + ' ' + I18n.t('mailers.user.account_approved_instructions')
    from          Settings['general.admin_email_address']
    recipients    email_address
    sent_on       Time.now
    body          :login_url => login_url
  end

  def account_rejected_instructions(email_address)
    subject       I18n.t('mailers.subject_prefix') + ' ' + I18n.t('mailers.user.account_rejected_instructions')
    from          Settings['general.admin_email_address']
    recipients    email_address
    sent_on       Time.now
  end

end
