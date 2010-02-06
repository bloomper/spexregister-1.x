class UpdateFrequencyExclAdministratorsReport < UpdateFrequencyReport
  
  protected
  def user_valid?(user)
    user.user_groups.each do |user_group|
      return false if user_group.name == 'Administrators'
    end
    true
  end
  
end
