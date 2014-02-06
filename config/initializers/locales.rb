AVAILABLE_LOCALES = {}

path = File.join(RAILS_ROOT, 'config', 'locales')

if File.exists? path
  locales = Dir.new(path).entries.collect do |x|
    x =~ /\.yml/ ? x.sub(/\.yml/,"") : nil
  end.compact.each_with_object({}) do |str, hsh|
    locale_file = YAML.load_file(path + "/" + str + ".yml")
    hsh[str] = locale_file[str]["language"] if locale_file.has_key? str
  end.freeze
  
  AVAILABLE_LOCALES.merge! locales
end
