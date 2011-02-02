class StreckListReport < BaseReport
  
  def generate
    xml = Builder::XmlMarkup.new(:indent => 2)
    xml.instruct!
    spexare_items = Spexare.by_spex(params[:id])
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
