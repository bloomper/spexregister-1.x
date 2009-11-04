module UserGroupsHelper
  
  def translate_user_group(user_group)
    t("user_group.name.#{user_group.downcase}")
  end
  
end
