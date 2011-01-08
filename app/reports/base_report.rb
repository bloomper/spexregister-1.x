class BaseReport < Struct.new(:ids)

  def new_record?
    true
  end
  
  def has_conditions?
    false
  end
  
  def set_conditions(conditions)
    @conditions = conditions
  end
  
  def formats
    []
  end

end
