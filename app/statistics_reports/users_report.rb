class UsersReport
  attr_reader :result

  def initialize(params = {})
    @result = {}
  end

  def generate_report_data!
    @new_users = User.count(:group => 'DATETIME(created_at)')
    @accumulated_users = get_accumulated_users(User.all(:order => 'created_at asc'))
    max_y, min_y, min_time, max_time = nil
    @result[:data] = Hash.new { |h,k| h[k] = [] }
    @result[:opts] = Hash.new { |h,k| h[k] = {} }

    for new_user in @new_users
      # The time is in a string format and must be converted
      time_value = Time.parse new_user[0]
      time = Time.gm(time_value.year, time_value.month, time_value.day).to_i * 1000
      max_time = time unless max_time && max_time > time
      min_time = time unless min_time && min_time < time
      
      @result[:data][I18n.t('views.statistics_report.users_report.legend.new_users')] << [time, new_user[1]]
      max_y = new_user[1].to_i unless max_y && max_y > new_user[0].to_i
      min_y = new_user[1].to_i unless min_y && min_y < new_user[0].to_i
    end

    for accumulated_user in @accumulated_users
      time = Time.gm(accumulated_user[0].year, accumulated_user[0].month, accumulated_user[0].day).to_i * 1000
      max_time = time unless max_time && max_time > time
      min_time = time unless min_time && min_time < time
      
      @result[:data][I18n.t('views.statistics_report.users_report.legend.accumulated_users')] << [time, accumulated_user[1]]
      max_y = accumulated_user[1].to_i unless max_y && max_y > accumulated_user[0].to_i
      min_y = accumulated_user[1].to_i unless min_y && min_y < accumulated_user[0].to_i
    end

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
      lines: { show: true, steps: true },
      bars: { show: false }"
  end

  def new_record?
    true
  end

  private
  def get_accumulated_users(users)
    returning result = [] do
      if !users.blank?
        acculumated = 0
        current_time = users.first.created_at
        users.each do |user|
          if (current_time - user.created_at) != 0
            result << [current_time, acculumated]
            current_time = user.created_at
          end
          acculumated += 1
        end
        result << [current_time, acculumated]
      end
    end  
  end

end
