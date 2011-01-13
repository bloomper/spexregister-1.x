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
  
  def set_permissions(permissions)
    @permissions = permissions
  end
  
  def allowed_to_export_restricted_info(id = nil)
    @permissions[:admin] || @permissions[:spexare_id] == id
  end
  
  def formats
    []
  end

  def translate_boolean(value)
    value ? I18n.t('views.base.yes') : I18n.t('views.base.no')
  end

end
