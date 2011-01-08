class AddressLabelsReport < BaseReport
  
  def perform
    spexare_items = Spexare.find(ids)
    xml = Builder::XmlMarkup.new
    xml.instruct!
    xml.SpexareItems do
      spexare_items.each do |spexare|
        # TODO: Check conditions
        xml.Spexare do
          xml.FullName spexare.full_name
          xml.PostalCode spexare.postal_code
          xml.PostalAddress spexare.postal_address
          xml.Country I18n.t("countries.#{spexare.country}") unless spexare.country = "SV"
        end if go_ahead
      end
    end
  end

  def has_conditions?
    true
  end

  def formats
    ['PDF', 'RTF', 'ODT', 'DOCX', 'XML']
  end

end
