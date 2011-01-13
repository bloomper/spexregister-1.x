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
          xml.StreetAddress spexare.street_address unless spexare.deceased
          xml.PostalCode spexare.postal_code unless spexare.deceased
          xml.PostalAddress spexare.postal_address unless spexare.deceased
          xml.Country I18n.t("countries.#{spexare.country}") unless spexare.deceased
          xml.PhoneHome spexare.phone_home unless spexare.deceased
          xml.PhoneWork spexare.phone_work unless spexare.deceased
          xml.PhoneMobile spexare.phone_mobile unless spexare.deceased
          xml.PhoneOther spexare.phone_other unless spexare.deceased
          xml.EmailAddress spexare.email_address unless spexare.deceased
          xml.BirthDate spexare.birth_date
          xml.SocialSecurityNumber spexare.social_security_number if allowed_to_export_restricted_info(spexare.id)
          xml.ChalmersStudent translate_boolean(spexare.chalmers_student)
          xml.Graduation spexare.graduation
          xml.Deceased translate_boolean(spexare.deceased)
          xml.PublishApproval translate_boolean(spexare.publish_approval) if allowed_to_export_restricted_info(spexare.id)
          xml.WantCirculars translate_boolean(spexare.want_circulars) if allowed_to_export_restricted_info(spexare.id)
          xml.WantEmailCirculars translate_boolean(spexare.want_email_circulars) if allowed_to_export_restricted_info(spexare.id)
          xml.UncertainAddress translate_boolean(spexare.uncertain_address)
        end
      end
    end
  end

  def formats
    ['PDF', 'XLS', 'ODS', 'CSV', 'XML']
  end

end
