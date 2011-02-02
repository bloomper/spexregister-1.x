class BaseReport

  def has_conditions?
    false
  end
  
  def allowed_to_export_restricted_info(id = nil)
    @is_admin || (@user.spexare.nil? ? -1 : @user.spexare.id) == id
  end
  
  def set_user(user, is_admin)
    @user = user
    @is_admin = is_admin
  end
  
  def formats
    []
  end

  def translate_boolean(value)
    value ? I18n.t('views.base.yes') : I18n.t('views.base.no')
  end

end
