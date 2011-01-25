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
    data = @report.generate
    filename = "export." + params[:format].downcase
    send_data(data, :type => Mime::Type.lookup_by_extension(params[:format].downcase), :disposition => 'attachment', :filename => filename)
    # TODO Handle each format, respond_to?
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