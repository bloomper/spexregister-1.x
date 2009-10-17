class UserMailer < ActionMailer::Base
  default_url_options[:host] = ApplicationConfig.site_url
  
  def password_reset_instructions(user)
    subject       I18n.t('views.base.title') + ': ' + I18n.t('views.base.password_reset_instructions')
    from          ApplicationConfig.admin_mail_address
    recipients    user.spexare.emailaddress
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
  
end
