class BaseDashboardReport
  attr_reader :result

  def initialize(params = {})
    @result = {}
  end

  def new_record?
    true
  end

  protected
  def get_accumulated_entities(entities)
    [].tap do |result|
      if !entities.empty?
        accumulated = 0
        current_time = entities.first.created_at
        entities.each do |entity|
          if (current_time - entity.created_at) != 0
            result << [current_time, accumulated]
            current_time = entity.created_at
          end
          accumulated += 1
        end
        result << [current_time, accumulated]
      end
    end  
  end

end
