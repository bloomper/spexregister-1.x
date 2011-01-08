class DetailListReport < BaseReport
  
  def perform
    spexare_items = Spexare.find(ids)
    xml = Builder::XmlMarkup.new
    xml.instruct!
    xml.SpexareItems do
      spexare_items.each do |spexare|
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
          xml.BirthDate spexare.birth_date
          # TODO: Restrict
          xml.SocialSecurityNumber spexare.social_security_number
          xml.ChalmersStudent translate_boolean(spexare.chalmers_student)
          xml.Graduation spexare.graduation
          xml.Deceased translate_boolean(spexare.deceased)
          # TODO: Restrict
          xml.PublishApproval translate_boolean(spexare.publish_approval)
          # TODO: Restrict
          xml.WantCirculars translate_boolean(spexare.want_circulars)
          # TODO: Restrict
          xml.WantEmailCirculars translate_boolean(spexare.want_email_circulars)
          xml.UncertainAddress translate_boolean(spexare.uncertain_address)
        end
      end
    end
  end

  def formats
    ['PDF', 'XLS', 'ODS', 'CSV', 'XML']
  end

end
