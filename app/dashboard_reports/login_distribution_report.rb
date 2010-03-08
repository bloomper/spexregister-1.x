class LoginDistributionReport < BaseReport
  
  def generate_report_data!
    @logins = get_login_distribution
    @result[:data] = Hash.new { |h,k| h[k] = [] }
    @result[:opts] = Hash.new { |h,k| h[k] = {} }
    
    @logins.each_pair { |key, value|
      @result[:data][key] << [1, value]
    }
    
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
          label: \"#{I18n.t('views.dashboard_report.login_distribution_report.other')}\"
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
    login_distribution = {}
    User.find_each(:conditions => 'login_count > 0', :batch_size => 100) do |user|
      login_distribution.store(user.username, user.login_count)
    end
    return login_distribution
  end
  
end
