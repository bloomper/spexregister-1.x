class ReportGeneratorExecutor
  include Config
  
  def self.generate_report(xml_data, report_design, output_type, select_criteria)
    report_design << '.jasper' if !report_design.match(/\.jasper$/)
    interface_classpath=Dir.getwd+'/jasperreports/bin' 
    case CONFIG['host']
      when /mswin32/
        Dir.foreach('jasperreports/lib') do |file|
          interface_classpath << ";#{Dir.getwd}/jasperreports/lib/"+file if (file != '.' and file != '..' and file.match(/.jar/))
        end
      else
        Dir.foreach('jasperreports/lib') do |file|
          interface_classpath << ":#{Dir.getwd}/jasperreports/lib/"+file if (file != '.' and file != '..' and file.match(/.jar/))
        end
    end
    pipe = IO.popen "java -cp \"#{interface_classpath}\" XmlJasperReportsInterface -o#{output_type} -freports/#{report_design} -x#{select_criteria}", "w+b" 
    pipe.write xml_data
    pipe.close_write
    result = pipe.read
    pipe.close
    result
  end

end