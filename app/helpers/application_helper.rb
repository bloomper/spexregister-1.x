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
      request.request_uri.starts_with?("/#{options[:match_path]}")
    else
      args.include?(controller.controller_name.to_sym)
    end
    css_classes << 'selected' if selected
    
    if options[:css_class]
      css_classes << options[:css_class]
    end
    content_tag('li', link, :class => css_classes.join(' '))
  end
  
end
