module UsersHelper
  
  def translate_user_state(state)
    t("user.state.#{state.downcase}")
  end
  
  def get_available_states
    states = []
    User.aasm_states_for_select.each do |aasm_state|
      states << [translate_user_state(aasm_state.first), aasm_state.last]
    end
    states
  end
  
  def get_available_states_first_empty
    states = get_available_states
    states.insert(0, ['',''])
  end
  
  def link_to_state_events(user, options = {})
    options.assert_valid_keys(:url)
    options.reverse_merge! :url => user_url(user) unless options.key? :url
    
    if user.pending?
      construct_link_to_state_event('approve', options[:url]) +
      construct_link_to_state_event('reject', options[:url])
    elsif user.active? 
      construct_link_to_state_event('deactivate', options[:url])
    elsif user.inactive? 
      construct_link_to_state_event('activate', options[:url])
    elsif user.rejected? 
      construct_link_to_state_event('activate', options[:url])
    end
  end
  
  private
  def construct_link_to_state_event(event_type, base_url)
    url = base_url.index('?') ? base_url.dup.insert(base_url.index('?'), '/' + event_type) : base_url + '/' + event_type 
    link_to_function icon_tag(event_type) + ' ' + t("views.user.#{event_type}_event"), " 
      jQuery.ajax({
        type: 'POST',
        url: '#{url}',
        data: ({_method: 'put', authenticity_token: AUTH_TOKEN}),
        success: function(r){ eval(r); },
        failure: function(r){ eval(r); } 
      });"
  end
  
end
