# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def tab(*args)
    options = {:label => args.first.to_s}
    if args.last.is_a?(Hash)
      options = options.merge(args.pop)
    end
    options[:route] ||= args.first
    destination_url = send("#{options[:route]}_path")
    options[:translation_key] ||= "views.#{options[:label]}.title"
    label = t(options[:translation_key])
    link = link_to(label, destination_url)
    
    return("") if link.nil? || link.blank?
    
    css_classes = []
    selected = if options[:match_path]
     (request.request_uri + '/').starts_with?(options[:match_path] + '/') || request.request_uri.starts_with?(options[:match_path] + '?') 
    else
      args.include?(controller.controller_name.to_sym)
    end
    css_classes << 'selected' if selected
    
    if options[:css_class]
      css_classes << options[:css_class]
    end
    content_tag('li', link, :class => css_classes.join(' '))
  end
  
  def button_link_to_remote(text, options, html_options = {})    
    link_to_remote(text_for_button_link(text, html_options), options, html_options_for_button_link(html_options))
  end
  
  def text_for_button_link(text, html_options)
    s = ''
    if html_options[:icon]
      s << icon_tag(html_options.delete(:icon)) + ' &nbsp; '
    end
    s << text
    content_tag('span', s)
  end
  
  def link_to_remote(name, options = {}, html_options = {})
    options[:before] ||= "jQuery(this).parent().hide();"
    link_to_function(name, remote_function(options), html_options || options.delete(:html))
  end
  
  def html_options_for_button_link(html_options)
    options = {:class => 'button'}.update(html_options)
  end
  
  def button(text, button_type = 'submit')
    content_tag('button', content_tag('span', text), :type => button_type)
  end
  
  def icon_tag(icon_name)
    image_tag("/images/#{icon_name}.png")
  end
  
  def link_to_with_icon(icon_name, text, url, options = {})
    link_to(icon_tag(icon_name) + ' ' + text, url, options)
  end
  
  def link_to_view_action(resource)
    link_to_with_icon('view', t('views.base.view_action'), resource_url(resource))
  end
  
  def link_to_edit_action(resource)
    link_to_with_icon('edit', t('views.base.edit_action'), edit_resource_url(resource))
  end
  
  def link_to_delete_action(resource, options = {})
    options.assert_valid_keys(:url, :caption, :title)
    
    options.reverse_merge! :url => resource_url(resource) unless options.key? :url
    options.reverse_merge! :caption => t('views.base.are_you_sure')
    options.reverse_merge! :title => t('views.base.confirm_delete')
    
    link_to_function icon_tag('delete') + ' ' + t('views.base.delete_action'), "jConfirm('#{options[:caption]}', '#{options[:title]}', function(r) { 
      if(r){ 
        jQuery.ajax({
          type: 'POST',
          url: '#{options[:url]}',
          data: ({_method: 'delete', authenticity_token: AUTH_TOKEN}),
          success: function(r){ jQuery('##{dom_id resource}').fadeOut('hide'); eval(r); },
          failure: function(r){ eval(r); } 
        });
      }
    });"
  end
  
  def translate_boolean(value)
    value ? t('views.base.yes') : t('views.base.no')
  end
  
  def field_container(model, method, options = {}, &block)
    unless error_message_on(model, method).blank?
      css_class = 'withError' 
    end
    html = content_tag('p', capture(&block), :class => css_class)
    concat(html)
  end

  def flag_image(locale)
    "#{extract_language_from_locale(locale)}.png"
  end
  
  def extract_language_from_locale(locale)
    locale.to_s.split("-").last.downcase
  end

  def get_username_by_id(id)
    if !id.nil?
      begin
        User.find_by_id(id).username
      rescue ActiveRecord::RecordNotFound
      end
    end
  end

  def page_entries_info(collection, options = {})
    entry_translation_group_key = options[:entry_translation_group_key]
    if collection.total_pages < 2
      case collection.size
      when 0; t('views.base.page_entries_none_found', :entry_name => t(entry_translation_group_key, :count => 0))
      when 1; t('views.base.page_entries_showing_one', :entry_name => t(entry_translation_group_key, :count => 1))
      else; t('views.base.page_entries_showing_all', :entry_name => t(entry_translation_group_key, :count => collection.size), :number_of_hits => collection.size)
      end
    else
      t('views.base.page_entries_showing', :entry_name => t(entry_translation_group_key, :count => collection.total_entries), :start => collection.offset + 1, :end => collection.offset + collection.length, :total => collection.total_entries)
    end
  end

end
