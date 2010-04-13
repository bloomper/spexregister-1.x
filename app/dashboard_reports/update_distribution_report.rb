class UpdateDistributionReport < BaseDashboardReport
  
  def generate_report_data!
    @updates = get_update_distribution
    @result[:data] = Hash.new { |h,k| h[k] = [] }
    @result[:opts] = Hash.new { |h,k| h[k] = {} }
    
    @updates.each_pair { |key, value|
      @result[:data][key] << [1, value]
    }
    
    if !@updates.empty?
      @result[:opts][:series] = "
        pie: {
         show: true,
         tilt: 0.5,
         label: {
          show: true,
          radius: 0.8,
          formatter: function(label, slice){
            return '<div style=\"font-size:x-small;text-align:center;padding:2px;color:#365c8a;\">'+Math.round(slice.percent)+'%&nbsp;('+slice.data[0][1]+')</div>';
          }
         },
         combine: {
          threshold: 0.01,
          label: \"#{I18n.t('views.dashboard_report.update_distribution_report.other')}\"
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
  def get_update_distribution
    update_distribution = {}
    # Since parents are touched when a child is updated, it is sufficient to check the top parent
    Spexare.find_each(:batch_size => 100) do |spexare|
      username = get_user_name(spexare.updated_by)
      if !username.nil?
        if update_distribution.has_key?(username)
          old_value = update_distribution.fetch(username)
          update_distribution.store(username, old_value += 1)
        else
          update_distribution.store(username, 1)
        end
      end
    end
    return update_distribution
  end
  
  @@user_cache = {}
  
  def get_user_name(id)
    return @@user_cache.fetch(id) if @@user_cache.has_key?(id)
    user = User.find_by_id(id)
    if !user.nil? && user_valid?(user)
      @@user_cache.store(id, user.username)
      return user.username
    else
      return nil
    end
  end
  
  def user_valid?(user)
    true
  end

end
