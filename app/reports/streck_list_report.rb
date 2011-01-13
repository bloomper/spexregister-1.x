class StreckListReport < BaseReport
  
  def perform
    spexare_items = Spexare.by_spex(ids[0])
    xml = Builder::XmlMarkup.new
    xml.instruct!
    xml.SpexareItems do
      spexare_items.each do |spexare|
        xml.Spexare do
          xml.FullName spexare.full_name
        end
      end
    end
  end

  def formats
    ['PDF', 'RTF', 'ODT', 'DOCX', 'XLS', 'ODS', 'CSV', 'XML']
  end

end
