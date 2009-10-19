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
      request.request_uri.eql?(options[:match_path])
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
    options[:before] ||= "$(this).parent().hide(); $('#busy_indicator').show();"
    options[:complete] ||= "$('#busy_indicator').hide()"
    link_to_function(name, remote_function(options), html_options || options.delete(:html))
  end
  
  def html_options_for_button_link(html_options)
    options = {:class => 'button'}.update(html_options)
  end

  def icon_tag(icon_name)
    image_tag("/images/#{icon_name}.png")
  end

  def link_to_with_icon(icon_name, text, url, options = {})
    link_to(icon_tag(icon_name) + ' ' + text, url, options)
  end

  def link_to_edit_action(url)
    link_to_with_icon('edit', t("views.base.edit_action"), url)
  end

  def link_to_delete_action(id, url, options = {})
    options.assert_valid_keys(:url, :caption, :title)

    options.reverse_merge! :url => url unless options.key? :url
    options.reverse_merge! :caption => t('views.base.are_you_sure')
    options.reverse_merge! :title => t('views.base.confirm_delete')

    link_to_function icon_tag("delete") + ' ' + t("views.base.delete_action"), "jConfirm('#{options[:caption]}', '#{options[:title]}', function(r) { 
      if(r){ 
        $.ajax({
          type: 'POST',
          url: '#{options[:url]}',
          data: ({_method: 'delete', authenticity_token: AUTH_TOKEN}),
          success: function(r){ $('##{id}').fadeOut('hide'); } 
        });
      }
    });"
  end

end
