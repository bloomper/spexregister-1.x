module ActivitiesHelper
  
  def setup_activity(activity)
    returning activity do |a|
      a.function_activities.build if a.function_activities.empty?
    end
  end

end
