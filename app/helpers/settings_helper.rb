module SettingsHelper
  
  def get_non_selected_functions(ids)
    if ids.blank?
      Function.all
    else
      Function.find(:all, :conditions => ['id not in (?)', ids.split(',').collect{ |s| s.to_i }])
    end
  end
  
  def get_selected_functions(ids)
    if ids.blank?
      []
    else
      Function.find(ids.split(',').collect{ |s| s.to_i })
    end
  end

end
