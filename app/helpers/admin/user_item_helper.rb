module Admin::UserItemHelper

  def get_roles
    RoleItem.to_dropdown
  end
end
