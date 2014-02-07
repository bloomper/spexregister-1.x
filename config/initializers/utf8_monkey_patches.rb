# Make sure the logger supports encodings properly.
module ActiveSupport
  class BufferedLogger
    def add(severity, message = nil, progname = nil, &block)
      return if @level > severity
      message = (message || (block && block.call) || progname).to_s

      # If a newline is necessary then create a new message ending with a newline.
      # Ensures that the original message is not mutated.
      message = "#{message}\n" unless message[-1] == ?\n
      buffer << message.force_encoding(Encoding.default_external)
      auto_flush
      message
    end
  end
end

# This makes it so all parameters get converted to UTF-8 before they hit your app.  If someone sends invalid UTF-8 to your server, raise an exception.
# At UserVoice, we rescue this exception and show a custom error page.
class ActionController::InvalidByteSequenceErrorFromParams < Encoding::InvalidByteSequenceError; end
class ActionController::Base

  def force_utf8_params
    traverse = lambda do |object, block|
      if object.kind_of?(Hash)
        object.each_value { |o| traverse.call(o, block) }
      elsif object.kind_of?(Array)
        object.each { |o| traverse.call(o, block) }
      else
        block.call(object)
      end
      object
    end
    force_encoding = lambda do |o|
      if o.respond_to?(:force_encoding)
        o.force_encoding(Encoding::UTF_8)
        raise ActionController::InvalidByteSequenceErrorFromParams unless o.valid_encoding?
      end
      if o.respond_to?(:original_filename)
        o.original_filename.force_encoding(Encoding::UTF_8)
        raise ActionController::InvalidByteSequenceErrorFromParams unless o.original_filename.valid_encoding?
      end
    end
    traverse.call(params, force_encoding)
    path_str = request.path.to_s
    if path_str.respond_to?(:force_encoding)
      path_str.force_encoding(Encoding::UTF_8)
      raise ActionController::InvalidByteSequenceErrorFromParams unless path_str.valid_encoding?
    end
  end
  before_filter :force_utf8_params
end


# Serialized columns in AR don't support UTF-8 well, so set the encoding on those as well.
class ActiveRecord::Base
  def unserialize_attribute_with_utf8(attr_name)
    traverse = lambda do |object, block|
      if object.kind_of?(Hash)
        object.each_value { |o| traverse.call(o, block) }
      elsif object.kind_of?(Array)
        object.each { |o| traverse.call(o, block) }
      else
        block.call(object)
      end
      object
    end
    force_encoding = lambda do |o|
      o.force_encoding(Encoding::UTF_8) if o.respond_to?(:force_encoding)
    end
    value = unserialize_attribute_without_utf8(attr_name)
    traverse.call(value, force_encoding)
  end
  alias_method_chain :unserialize_attribute, :utf8
end

# Make sure the flash sets the encoding to UTF-8 as well.
module ActionController
  module Flash
    class FlashHash
      def [](k)
        v = super
        v.is_a?(String) ? v.force_encoding("UTF-8") : v
      end
    end
  end
end

module ActionController
  class Request
    private
    # Convert nested Hashs to HashWithIndifferentAccess and replace
    # file upload hashs with UploadedFile objects
    def normalize_parameters(value)
      case value
        when Hash
          if value.has_key?(:tempfile)
            upload = value[:tempfile]
            upload.extend(UploadedFile)
            upload.original_path = value[:filename]
            upload.content_type = value[:type]
            upload
          else
            h = {}
            value.each { |k, v| h[k] = normalize_parameters(v) }
              h.with_indifferent_access
          end
        when Array
           value.map { |e| normalize_parameters(e) }
        else
           value.force_encoding(Encoding::UTF_8) if value.respond_to?(:force_encoding)
           value
        end
    end
  end
end

module ActionView
  module Renderable #:nodoc:
    private
      def compile!(render_symbol, local_assigns)
        locals_code = local_assigns.keys.map { |key| "#{key} = local_assigns[:#{key}];" }.join
        source = <<-end_src
def #{render_symbol}(local_assigns)
old_output_buffer = output_buffer;#{locals_code};#{compiled_source}
ensure
self.output_buffer = old_output_buffer
end
end_src
        source.force_encoding(Encoding::UTF_8) if source.respond_to?(:force_encoding)

        begin
          ActionView::Base::CompiledTemplates.module_eval(source, filename, 0)
        rescue Errno::ENOENT => e
          raise e # Missing template file, re-raise for Base to rescue
        rescue Exception => e # errors from template code
          if logger = defined?(ActionController) && Base.logger
            logger.debug "ERROR: compiling #{render_symbol} RAISED #{e}"
            logger.debug "Function body: #{source}"
            logger.debug "Backtrace: #{e.backtrace.join("\n")}"
          end
          raise ActionView::TemplateError.new(self, {}, e)
        end
      end
  end
end
