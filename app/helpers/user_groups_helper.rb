module UserGroupsHelper

  def get_available_user_groups
    UserGroup.to_dropdown
  end

end
