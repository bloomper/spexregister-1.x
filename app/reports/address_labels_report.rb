class AddressLabelsReport < BaseReport
  
  def perform
    spexare_items = Spexare.find(ids)
    xml = Builder::XmlMarkup.new
    xml.instruct!
    xml.SpexareItems do
      spexare_items.each do |spexare|
        if @conditions[:include_with_missing_address]
          go_ahead = true
        elsif spexare.street_address.empty? && spexare.postal_code.empty? && spexare.postal_address.empty?
          go_ahead = false
        else
          go_ahead = true
        end
        # TODO: Merge
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
