class << ActiveRecord::Base
  def skip_callback(callback, &block)
    method = instance_method(callback)
    remove_method(callback) if respond_to?(callback)
    define_method(callback){ true }
    yield
    remove_method(callback)
    define_method(callback, method)
  end
end
