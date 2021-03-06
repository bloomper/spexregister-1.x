# MailQueue

module ActionMailer
  class Base
    
    class << self
      alias_method :orig_method_missing, :method_missing
    
      def method_missing(method_symbol, *parameters)#:nodoc:
        case method_symbol.id2name
          when /^deliver_([_a-z]\w*)\!/ then orig_method_missing(method_symbol, *parameters)
          when /^deliver_([_a-z]\w*)/ then queue_mail($1, *parameters)
          else orig_method_missing(method_symbol, *parameters)
        end
      end
    
      def queue_mail(method_name, *parameters)
        mail = new(method_name, *parameters).mail
        qmail = QueuedMail.new
        qmail.object = mail
        qmail.mailer = self.to_s

        qmail.save!
      end
    end
  end
end


class MailQueue < ActiveRecord::Base
  
  
  def MailQueue.process
    
    for qmail in QueuedMail.find(:all)
      
      mailer = qmail.mailer.constantize
      mailer.deliver(qmail.object)
      qmail.destroy
      
    end
  end

end

