require 'inherited_resources/responder'

Responders::FlashResponder.flash_keys = [ :success, :failure ]

class InheritedResources::Responder
  def to_js
    set_flash_message! if set_flash_message?
    default_render
  end
end