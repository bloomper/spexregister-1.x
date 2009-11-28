module ActorsHelper
  
  def get_available_vocals
    Actor.vocals.collect {|p| [ p.title, p.id ] }
  end

end
