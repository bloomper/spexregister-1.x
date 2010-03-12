class StreckListReport < BaseReport
  
  def perform
    spexare_items = Spexare.find(ids)
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

end
