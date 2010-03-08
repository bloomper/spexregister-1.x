class UsersReport < BaseReport

  def generate_report_data!
    @new_users = User.count(:group => 'DATETIME(created_at)')
    @accumulated_users = get_accumulated_entities(User.all(:order => 'created_at asc'))
    max_y, min_y, min_time, max_time = nil
    @result[:data] = Hash.new { |h,k| h[k] = [] }
    @result[:opts] = Hash.new { |h,k| h[k] = {} }

    for new_user in @new_users
      # Apparently Rails does not convert the time into a TimeZone object nor switching from UTC (as stored in database) to relevant time zone
      time_value = DateTime.strptime(new_user[0], '%Y-%m-%d %H:%M:%S').to_time.in_time_zone
      time = Time.gm(time_value.year, time_value.month, time_value.day, time_value.hour, time_value.min, time_value.sec).to_i * 1000
      max_time = time unless max_time && max_time > time
      min_time = time unless min_time && min_time < time
      
      @result[:data][I18n.t('views.statistics_report.users_report.legend.new_users')] << [time, new_user[1]]
      max_y = new_user[1].to_i unless max_y && max_y > new_user[1].to_i
      min_y = new_user[1].to_i unless min_y && min_y < new_user[1].to_i
    end

    for accumulated_user in @accumulated_users
      time = Time.gm(accumulated_user[0].year, accumulated_user[0].month, accumulated_user[0].day, accumulated_user[0].hour, accumulated_user[0].min, accumulated_user[0].sec).to_i * 1000
      max_time = time unless max_time && max_time > time
      min_time = time unless min_time && min_time < time
      
      @result[:data][I18n.t('views.statistics_report.users_report.legend.accumulated_users')] << [time, accumulated_user[1]]
      max_y = accumulated_user[1].to_i unless max_y && max_y > accumulated_user[1].to_i
      min_y = accumulated_user[1].to_i unless min_y && min_y < accumulated_user[1].to_i
    end

    if !@new_users.empty? || !@accumulated_users.empty?
      min_y = 0 if min_y > 0
      max_y += 1
  
      @result[:opts][:y_axis] = "
        min: #{min_y},
        max: #{max_y},
        zoomRange: [#{max_y - min_y}, #{max_y - min_y}],
        panRange: [#{min_y}, #{max_y}]"
  
      @result[:opts][:x_axis] = "
        mode: 'time',
        zoomRange: #{[1000 * 60 * 60 * 24 * 7, max_time - min_time]},
        panRange: #{[min_time, max_time]},
        monthNames: [#{I18n.t('views.statistics_report.month_names')}]"
  
      @result[:opts][:series] = "
        points: { show: true, radius: 5 },
        lines: { show: true, lineWidth: 1, steps: true },
        bars: { show: false }"
  
      @result[:opts][:grid] = "
        hoverable: true,
        show_tooltips: true"
  
      @result[:opts][:zoom] = "
        interactive: true"
  
      @result[:opts][:pan] = "
        interactive: true"
  
      @result[:opts][:legend] = "
        container: '#flot-legend'"
    end
  end

end
