class Mailer < ActionMailer::Base

  def signup(new_account_email_address, new_account_name, new_account_user_name, new_account_description, recipient)
    @charset = 'UTF-8'
    @subject = 'Meddelande från Chalmersspexets Adressregister'
    @recipients = recipient
    @from = new_account_email_address
    @sent_on = Time.now
    @body = { 'new_account_name' => new_account_name, 'new_account_user_name' => new_account_user_name, 'new_account_description' => new_account_description }
  end
  
  def mail_distribution(args = {})
    args.stringify_keys!
    @charset = 'UTF-8'
    @recipients = args['recipient']
    @from = args['sender_address']
    @subject = args['subject']
    @sent_on = Time.now
    @body = { 'mail_body' => args['mail_body'] }
  end
  
  def mail_distribution_result_success(args = {})
    args.stringify_keys!
    @charset = 'UTF-8'
    @recipients = args['sender_address']
    @from = args['admin_mail_address']
    @subject = 'Meddelande från Chalmersspexets Adressregister'
    @sent_on = Time.now
    @body = { 'subject' => args['subject'], 'recipients' => args['recipients'] }
  end

  def mail_distribution_result_failure(args = {})
    args.stringify_keys!
    @charset = 'UTF-8'
    @recipients = args['sender_address']
    @from = args['admin_mail_address']
    @subject = 'Meddelande från Chalmersspexets Adressregister'
    @sent_on = Time.now
    @body = { 'subject' => args['subject'], 'admin_mail_address' => args['admin_mail_address'] }
  end

end
