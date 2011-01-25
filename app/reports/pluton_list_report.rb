class PlutonListReport < BaseReport
  
  def generate
    xml = Builder::XmlMarkup.new
    xml.instruct!
    spexare_items = Spexare.by_spex(params[:id])
    # TODO: Ordering
    # TODO: Header
    xml.SpexareItems do
      spexare_items.each do |spexare|
        xml.Spexare do
          # TODO: Role
          xml.FirstName spexare.first_name
          xml.LastName spexare.last_name
          xml.NickName spexare.nick_name
          xml.StreetAddress spexare.street_address
          xml.PostalCode spexare.postal_code
          xml.PostalAddress spexare.postal_address
          xml.PhoneHome spexare.phone_home
          xml.PhoneMobile spexare.phone_mobile
          xml.EmailAddress spexare.email_address
          xml.BirthDate spexare.birth_date
        end
      end
    end
  end

  def formats
    ['PDF', 'RTF', 'ODT', 'DOCX', 'XML']
  end

end
