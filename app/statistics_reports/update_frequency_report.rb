class UpdateFrequencyReport < BaseReport
  
  def generate_report_data!
    @updates = get_update_frequencies
    @result[:data] = Hash.new { |h,k| h[k] = [] }
    @result[:opts] = Hash.new { |h,k| h[k] = {} }
    
    @updates.each_pair { |key, value|
      @result[:data][key] << [1, value]
    }
    
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
        label: \"#{I18n.t('views.statistics_report.update_frequency_report.other')}\"
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
  
  protected
  def get_update_frequencies
    update_freqs = {}
    entities = Spexare.find(:all, :order => 'updated_by asc') | Activity.find(:all, :order => 'updated_by asc') | SpexActivity.find(:all, :order => 'updated_by asc') | FunctionActivity.find(:all, :order => 'updated_by asc') | Actor.find(:all, :order => 'updated_by asc')
    entities.each do |entity|
      username = get_user_name(entity.updated_by)
      if !username.nil?
        if update_freqs.has_key?(username)
          old_value = update_freqs.fetch(username)
          update_freqs.store(username, old_value += 1)
        else
          update_freqs.store(username, 1)
        end
      end
    end
    return update_freqs
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
