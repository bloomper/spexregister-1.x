class LoginDistributionReport < BaseReport

  def generate_report_data!
    @logins = get_login_distribution
    @result[:data] = Hash.new { |h,k| h[k] = [] }
    @result[:opts] = Hash.new { |h,k| h[k] = {} }

    for login in @logins
      @result[:data][login.username] << [1, login.login_count]
    end

    if !@logins.empty?
      @result[:opts][:series] = "
        pie: {
         show: true,
         tilt: 0.5,
         label: {
          show: true,
          radius: 0.8,
          formatter: function(label, slice){
            return '<div style=\"font-size:x-small;text-align:center;padding:2px;color:'+slice.color+';\">'+Math.round(slice.percent)+'%&nbsp;('+slice.data[0][1]+')</div>';
          }
         },
         combine: {
          threshold: 0.01,
          label: \"#{I18n.t('views.statistics_report.login_distribution_report.other')}\"
         }
        }"
  
      @result[:opts][:grid] = "
        hoverable: false,
        show_tooltips: false"
  
      @result[:opts][:zoom] = "
        interactive: false"
  
      @result[:opts][:pan] = "
        interactive: false"
  
      @result[:opts][:legend] = "
        container: '#flot-legend'"
    end
  end

  protected
  def get_login_distribution
    User.find(:all, :conditions => 'login_count > 0', :order => 'login_count asc')
  end

end
