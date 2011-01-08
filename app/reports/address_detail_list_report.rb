class AddressDetailListReport < BaseReport
  
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
        xml.Spexare do
          xml.FirstName spexare.first_name
          xml.LastName spexare.last_name
          xml.NickName spexare.nick_name
          xml.StreetAddress spexare.street_address
          xml.PostalCode spexare.postal_code
          xml.PostalAddress spexare.postal_address
          xml.Country I18n.t("countries.#{spexare.country}")
          xml.PhoneHome spexare.phone_home
          xml.PhoneWork spexare.phone_work
          xml.PhoneMobile spexare.phone_mobile
          xml.PhoneOther spexare.phone_other
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
