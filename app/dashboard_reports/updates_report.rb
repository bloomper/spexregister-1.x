class UpdatesReport < BaseDashboardReport

  def generate_report_data!
    # Since parents are touched when a child is updated, it is sufficient to check the top parent
    @updates = Spexare.count(:group => 'updated_at')
    max_y, min_y, min_time, max_time = nil
    @result[:data] = Hash.new { |h,k| h[k] = [] }
    @result[:opts] = Hash.new { |h,k| h[k] = {} }

    for update in @updates
      time = update[0].in_time_zone.to_i * 1000 + Time.zone.utc_offset * 1000
      max_time = time unless max_time && max_time > time
      min_time = time unless min_time && min_time < time
      
      @result[:data][I18n.t('views.dashboard_report.updates_report.legend.update')] << [time, update[1]]
      max_y = update[1].to_i unless max_y && max_y > update[1].to_i
      min_y = update[1].to_i unless min_y && min_y < update[1].to_i
    end

    if !@updates.empty?
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
        monthNames: [#{I18n.t('views.dashboard_report.month_names')}]"
  
      @result[:opts][:series] = "
        points: { show: false },
        lines: { show: false },
        bars: { show: true }"
  
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
