class DetailedSummaryReport < BaseReport
  
  def perform
    spexare_items = Spexare.find(ids[0])
  end

  def formats
    ['PDF', 'RTF', 'ODT', 'DOCX', 'XML']
  end

end
