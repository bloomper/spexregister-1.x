class DetailedSummaryReport < BaseReport
  
  def generate
    spexare_item = Spexare.find(params[:id])
  end

  def formats
    ['PDF', 'RTF', 'ODT', 'DOCX', 'XML']
  end

end
