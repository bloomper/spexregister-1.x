require 'erubis/helpers/rails_helper'

module RailsXss
  class Erubis < ::Erubis::Eruby
    def add_preamble(src)
      src << "@output_buffer = ActiveSupport::SafeBuffer.new;"
    end

    def add_text(src, text)
      return if text.empty?
      src << "@output_buffer.safe_concat('" << escape_text(text) << "');"
    end

    BLOCK_EXPR = /\s+(do|\{)(\s*\|[^|]*\|)?\s*\Z/

    def add_expr_literal(src, code)
      if code =~ BLOCK_EXPR
        src << "@output_buffer.safe_concat((" << $1 << ").to_s);"
      else
        src << '@output_buffer << ((' << code << ').to_s);'
      end
    end

    def add_expr_escaped(src, code)
      src << '@output_buffer << ' << escaped_expr(code) << ';'
    end

    def add_postamble(src)
      src << '@output_buffer.to_s'
    end
  end
end

Erubis::Helpers::RailsHelper.engine_class = RailsXss::Erubis
Erubis::Helpers::RailsHelper.show_src = false
