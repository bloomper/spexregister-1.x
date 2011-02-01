module SettingsHelper
  
  def get_non_selected_functions(ids)
    ids.blank? ? Function.all : Function.find(:all, :conditions => ['id not in (?)', ids.split(',').collect{ |s| s.to_i }]) 
  end
  
  def get_selected_functions(ids)
    ids.blank? ? [] : Function.find(ids.split(',').collect{ |s| s.to_i })
  end

end
