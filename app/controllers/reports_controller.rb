class ReportsController < ApplicationController
  around_filter :inject_methods

  def new
    @report = Object.const_get(params[:report].camelize + 'Report').new
    @report.set_user(current_user, current_user_is_admin?)
    respond_to do |format|
      format.html { render :action => :new, :layout => false }
    end
  end

  def create
    @report = Object.const_get(params[:report].camelize + 'Report').new
    @report.set_user(current_user, current_user_is_admin?)
    xml_data = @report.generate
    if params[:format].downcase != 'xml'
      data = generate_report(xml_data, @report.initial_select, params[:report], params[:format].downcase)
    end
    filename = 'export_' + Time.now.strftime('%Y%m%d_%H%M%S') + '.' + params[:format].downcase
    send_data(params[:format].downcase != 'xml' ? data : xml_data, :type => Mime::Type.lookup_by_extension(params[:format].downcase), :disposition => 'attachment', :filename => filename)
  end

  protected
  def current_user_is_admin
    current_user_is_admin?
  end

  def inject_methods
    klasses = [BaseReport, BaseReport.class]
    methods = ['session', 'params', 'request']

    methods.each do |method|
      variable = instance_variable_get(:"@_#{method}") 

      klasses.each do |klass|
        klass.send(:define_method, method, proc { variable })
      end
    end

    yield

    methods.each do |method|      
      klasses.each do |klass|
        klass.send :remove_method, method
      end
    end
  end
  
  private
  def generate_report(xml_data, xpath_select, report, format = 'pdf')
    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] = ''
      headers['Cache-Control'] = ''
    else
      headers['Pragma'] = 'no-cache'
      headers['Cache-Control'] = 'no-cache, must-revalidate'
    end
    conn = Faraday::Connection.new(:url => Settings['reports.generator_url'])
    resp = conn.post do |req|
      req.url 'generate', :report => report, :format => format, :selectCriteria => xpath_select
      req["Content-Type"] = 'application/xml'
      req.body = xml_data
    end
    # TODO: Error handling
    resp.body
  end

end