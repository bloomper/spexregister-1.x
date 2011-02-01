module SettingsHelper
  
  def get_non_selected_functions(ids)
    ids.blank? ? Function.all : Function.find(:all, :conditions => ['id not in (?)', ids.split(',').collect{ |s| s.to_i }]) 
  end
  
  def get_selected_functions(ids)
    ids.blank? ? [] : Function.find(ids.split(',').collect{ |s| s.to_i }, :order => "#{order_by_case('id', ids)}")
  end

  def order_by_case(column, ids)
    expr = "case #{column}"
    ids.split(',').each_with_index do |id, index|
      expr += " when #{id} then #{index} "
    end
    expr += 'end'
  end

end
