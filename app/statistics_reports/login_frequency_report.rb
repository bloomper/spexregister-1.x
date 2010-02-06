class LoginFrequencyReport < BaseReport

  def generate_report_data!
    @login_frequencies = User.find(:all, :conditions => 'login_count > 0', :order => 'login_count asc')
    @result[:data] = Hash.new { |h,k| h[k] = [] }
    @result[:opts] = Hash.new { |h,k| h[k] = {} }

    for login_frequency in @login_frequencies
      @result[:data][login_frequency.username] << [1, login_frequency.login_count]
    end

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
        label: \"#{I18n.t('views.statistics_report.login_frequency_report.other')}\"
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
