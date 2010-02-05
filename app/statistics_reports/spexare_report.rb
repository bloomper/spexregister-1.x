class SpexareReport
  attr_reader :report_data

  def initialize(params = {})
    @report_data = {}
  end

  def generate_report_data!
  end

  def new_record?
    true
  end

end
