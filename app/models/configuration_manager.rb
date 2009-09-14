class ConfigurationManager

  def initialize
    configuration_items.clear
    ConfigurationItem.find(:all).each do |line|
      configuration_items[line.name.to_s] = line.value
    end
  end

  def [](key)
    configuration_items[key.to_s]
  end

  protected

  def configuration_items
    @hash ||= {}
  end

end
