require 'report_generator_executer.rb'

module ReportGenerator
  
  protected
  def cache_hack
    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] = ''
      headers['Cache-Control'] = ''
    else
      headers['Pragma'] = 'no-cache'
      headers['Cache-Control'] = 'no-cache, must-revalidate'
    end
  end

  def generate_report(xml, xml_start_path, report, filename, output_type = 'pdf')
    case output_type
    when 'rtf'
      extension = 'rtf'
      mime_type = 'application/rtf'
      jasper_type = 'rtf'
    when 'xls'
      extension = 'xls'
      mime_type = 'application/vnd.ms-excel'
      jasper_type = 'xls'
    when 'xml'
      extension = 'xml'
      mime_type = 'text/xml'
      jasper_type = 'xml'
    when 'csv'
      extension = 'csv'
      mime_type = 'text/csv'
      jasper_type = 'csv'
    else
      extension = 'pdf'
      mime_type = 'application/pdf'
      jasper_type = 'pdf'
    end

    cache_hack
    send_data ReportGeneratorExecutor.generate_report(xml, report, jasper_type, xml_start_path), :filename => "#{filename}.#{extension}", :type => mime_type, :disposition => 'attachment'
  end
end