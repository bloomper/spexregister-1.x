class LoginDistributionExclAdministratorsReport < LoginDistributionReport

  protected
  def get_login_distribution
    login_distribution = {}
    User.find_each(:conditions => 'login_count > 0 and not exists (select * from user_groups left join user_groups_users on user_groups_users.user_group_id = user_groups.id where name = "Administrators" and user_groups_users.user_id = users.id)', :joins => 'left join user_groups_users on user_groups_users.user_id = users.id left join user_groups on user_groups.id = user_groups_users.user_group_id', :batch_size => 100) do |user|
      login_distribution.store(user.username, user.login_count)
    end
    return login_distribution
  end

end
