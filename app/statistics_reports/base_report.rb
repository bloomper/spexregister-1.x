class BaseReport
  attr_reader :result

  def initialize(params = {})
    @result = {}
  end

  def new_record?
    true
  end

  protected
  def get_accumulated_entities(entities)
    returning result = [] do
      if !entities.empty?
        acculumated = 0
        current_time = entities.first.created_at
        entities.each do |entity|
          if (current_time - entity.created_at) != 0
            result << [current_time, acculumated]
            current_time = entity.created_at
          end
          acculumated += 1
        end
        result << [current_time, acculumated]
      end
    end  
  end

end
