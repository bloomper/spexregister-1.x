class EmailAddressDetailListReport < BaseReport
  
  def perform
    spexare_items = Spexare.find(ids)
    xml = Builder::XmlMarkup.new
    xml.instruct!
    xml.SpexareItems do
      spexare_items.each do |spexare|
        if @conditions[:include_with_missing_email_address]
          go_ahead = true
        elsif spexare.email_address.empty?
          go_ahead = false
        else
          go_ahead = true
        end
        xml.Spexare do
          xml.EmailAddress spexare.email_address
        end if go_ahead
      end
    end
  end

  def has_conditions?
    true
  end

  def formats
    ['PDF', 'XLS', 'ODS', 'CSV', 'XML']
  end

end
