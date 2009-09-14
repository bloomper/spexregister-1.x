class FilterOptions
  attr_accessor :filter
  def filter?
    !self.filter.blank?
  end
  def initialize(hash)
    if hash
      hash.each do |k,v|
        sym = "#{k}="
        self.send sym, v
      end
    end 
  end
end