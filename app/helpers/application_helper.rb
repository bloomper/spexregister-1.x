# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def tab(*args)
    options = {:label => args.first.to_s}
    if args.last.is_a?(Hash)
      options = options.merge(args.pop)
    end
    options[:route] ||= args.first
    options[:url_params] ||= {}
    destination_url = send("#{options[:route]}_path", options[:url_params])
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
    if options[:not_match_path] && ((request.request_uri + '/').starts_with?(options[:not_match_path] + '/') || request.request_uri.starts_with?(options[:not_match_path] + '?')) 
      selected = false
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
      s << icon_tag(html_options.delete(:icon)) + ' '
    end
    s << text
    content_tag('span', raw(s))
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
    options.assert_valid_keys(:url, :caption, :title, :table)
    
    options.reverse_merge! :url => resource_url(resource) unless options.key? :url
    options.reverse_merge! :caption => t('views.base.are_you_sure')
    options.reverse_merge! :title => t('views.base.confirm_delete')
    
    link_to_function icon_tag('delete') + ' ' + t('views.base.delete_action'), "jConfirm('#{options[:caption]}', '#{options[:title]}', function(r) { 
      if(r){ 
        jQuery.ajax({
          type: 'POST',
          url: '#{options[:url]}',
          data: ({_method: 'delete', authenticity_token: AUTH_TOKEN}),
          success: function(r){ jQuery('##{dom_id resource}').fadeOut('fast', function () { #{options[:table] ? 'jQuery.stripeTable(\'#' + options[:table] + '\');' : ''} }); },
          complete: function(r){ eval(r.responseText); } 
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
    user = User.find_by_id(id)
    return user.nil? ? nil : user.username
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
  
  def sanitized_object_name(object_name)
    object_name.gsub(/\]\[|[^-a-zA-Z0-9:.]/,"_").sub(/_$/,"")
  end
  
  def sanitized_method_name(method_name)
    method_name.sub(/\?$/, "")
  end
  
  def form_tag_id(object_name, method_name)
    "#{sanitized_object_name(object_name.to_s)}_#{sanitized_method_name(method_name.to_s)}"
  end 
  
  def remove_sub_link(name, f)
    f.hidden_field(:_destroy) + link_to_open(name, 'javascript:void(0)', :class => 'remove-sub')
  end
  
  def add_sub_link(name, association)
    link_to_open(name, 'javascript:void(0)', :class => 'add-sub', :'data-association' => association)
  end
  
  def new_sub_fields_template(form_builder, association, options = {})
    content_for "#{association}_fields_template" do
      options[:object] ||= form_builder.object.class.reflect_on_association(association).klass.new
      options[:partial] ||= association.to_s.singularize + '_form'
      options[:form_builder_local] ||= :f
      
      content_tag(:div, :id => "#{association}_fields_template", :style => 'display: none') do
        form_builder.fields_for(association, options[:object], :child_index => "new_#{association}") do |f|
          render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })
        end
      end
    end unless content_given?("#{association}_fields_template")
  end
  
  def content_given?(name)
    content = instance_variable_get("@content_for_#{name}")
    ! content.nil?
  end
  
  def whitespace(times = 1)
    '&nbsp;' * times
  end

  def print_text(text)
    if text.blank?
      return t 'views.base.missing_text'
    else
      h text
    end
  end

  def print_textarea(text)
    if text.blank?
      return t 'views.base.missing_text'
    else
      simple_format text
    end
  end

end
