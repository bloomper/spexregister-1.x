# Loose the div around fields with errors
ActionView::Base.field_error_proc = lambda {|tag, _| tag}

# So we get error messages wrapped in a span instead of a div which will tend to mess up forms
module ActionView::Helpers::ActiveRecordHelper  	

  def error_message_on(object, method, *args)
    options = args.extract_options!
    unless args.empty?
      ActiveSupport::Deprecation.warn('error_message_on takes an option hash instead of separate ' +
        'prepend_text, append_text, and css_class arguments', caller)

      options[:prepend_text] = args[0] || ''
      options[:append_text] = args[1] || ''
      options[:css_class] = args[2] || 'formError'
    end
    options.reverse_merge!(:prepend_text => '', :append_text => '', :css_class => 'formError')

    if (obj = (object.respond_to?(:errors) ? object : instance_variable_get("@#{object}"))) &&
      (errors = obj.errors.on(method))
      content_tag("span",
        "#{options[:prepend_text]}#{errors.is_a?(Array) ? errors.first : errors}#{options[:append_text]}",
        :class => options[:css_class]
      )
    else
      ''
    end
  end

end

# Allow some application_helper methods to be used in the scoped form_for manner
class ActionView::Helpers::FormBuilder
  
  def label(method, text = nil, options={})
    @template.label(@object_name,method,text,options)
  end

  def field_container(method, options = {}, &block)
    @template.field_container(@object_name,method,options,&block)
  end

  def nested_field_container(method, options = {}, &block)
    real_object_name = @object_name.split('[')[0]
    real_method = @object_name.gsub(/[\]]/, '').split('[')[1].gsub(/_attributes/, '') << "." << method.to_s
    @template.field_container(real_object_name,real_method,options,&block)
  end

  def nested_error_message_on(method, &args)
    real_object_name = @object_name.split('[')[0]
    real_method = @object_name.gsub(/[\]]/, '').split('[')[1].gsub(/_attributes/, '') << "." << method.to_s
    @template.error_message_on(real_object_name,real_method,&args)
  end

  def text_field_with_auto_complete(method, options = {}, auto_complete_options = {})
    text_field(method, options) + auto_complete_for(method, auto_complete_options)
  end

  def auto_complete_for(method, options = {})
    @template.auto_complete_for(@object_name, method, options)
  end

  %w(error_message_on).each do |selector|
    src = <<-end_src
      def #{selector}(method, options = {})
        @template.send(#{selector.inspect}, @object_name, method, objectify_options(options))
      end
    end_src
    class_eval src, __FILE__, __LINE__
  end

end
