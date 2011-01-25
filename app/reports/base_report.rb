class BaseReport

  def has_conditions?
    false
  end
  
  def allowed_to_export_restricted_info(id = nil)
    current_user_is_admin? || (current_user.spexare.nil? ? -1 : current_user.spexare.id) == id
  end
  
  def set_format(format)
    @format = format
  end

  def formats
    []
  end

  def translate_boolean(value)
    value ? I18n.t('views.base.yes') : I18n.t('views.base.no')
  end

end
