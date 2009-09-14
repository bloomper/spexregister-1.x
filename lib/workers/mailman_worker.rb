class MailmanWorker < BackgrounDRb::Worker::RailsBase

  def do_work(args)
    begin
      results[:progress] = 0
      recipients = args[:recipients].split(',') unless args[:recipients].nil?
      if !recipients.nil?
        progress_increment = (100.0 / recipients.length).ceil
        recipients.each do |recipient|
          Mailer.deliver_mail_distribution args.merge!(:recipient => recipient)
          results[:progress] += progress_increment
          if results[:progress] >= 100
            results[:progress] = 100
            results[:result] = 'SUCCESS'
            # The hash keys have been stringified in the mailer...
            if args['send_result']
              Mailer.deliver_mail_distribution_result_success args
            end
          end
        end
      else
        results[:result] = 'FAILURE'
        if args['send_result']
          Mailer.deliver_mail_distribution_result_failure args
        end
      end
    rescue Exception
      logger.error("Could not deliver mail due to #{$!.to_s}")
      results[:result] = 'FAILURE'
      if args['send_result']
        Mailer.deliver_mail_distribution_result_failure args
      end
    end
  end

  def progress
    results[:progress]
  end

  def result
    results[:result]
  end

end

MailmanWorker.register