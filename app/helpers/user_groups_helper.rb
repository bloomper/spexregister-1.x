module UserGroupsHelper

  def get_available_user_groups
    UserGroup.to_dropdown.each do |user_group|
      user_group[0] = t("user_group.name.#{user_group[0].downcase}")
    end
  end

end
