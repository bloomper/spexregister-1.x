module ActiveRecord
  class Base
    def self.clean_up_sql(sql)
      sanitize_sql(sql)
    end
  end
end

