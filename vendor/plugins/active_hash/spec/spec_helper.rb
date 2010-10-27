require 'spec'
require 'spec/autorun'
require 'active_record'
require 'fixjour'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'active_hash'

ActiveHash::Base.class_eval do
  def self.to_ary
  end

  def self.to_str
  end
end

Spec::Runner.configure do |config|
  config.include Fixjour
end
