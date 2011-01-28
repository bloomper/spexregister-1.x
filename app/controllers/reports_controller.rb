class ReportsController < ApplicationController
  around_filter :inject_methods

  def new
    @report = Object.const_get(params[:report].camelize + 'Report').new
    respond_to do |format|
      format.html { render :action => :new, :layout => false }
    end
  end

  def create
    @report = Object.const_get(params[:report].camelize + 'Report').new
    xml_data = @report.generate
    if params[:format].downcase != 'xml'
      # TODO: Invoke JasperServer
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
    methods = ["session", "params", "current_user_is_admin", "current_user"]

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

end