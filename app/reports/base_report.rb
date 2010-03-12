class BaseReport < Struct.new(:ids)

  def new_record?
    true
  end

end
