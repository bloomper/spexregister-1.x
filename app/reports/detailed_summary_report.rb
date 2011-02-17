class DetailedSummaryReport < BaseReport
  
  def generate
    xml = Builder::XmlMarkup.new(:indent => 2)
    xml.instruct!
    spexare = Spexare.find(params[:id])
    xml.Spexare do
      xml.FirstName spexare.first_name
      xml.LastName spexare.last_name
      xml.NickName spexare.nick_name
      xml.StreetAddress spexare.street_address
      xml.PostalCode spexare.postal_code
      xml.PostalAddress spexare.postal_address
      xml.Country spexare.country.blank? ? '' : I18n.t("countries.#{spexare.country}") 
      xml.PhoneHome spexare.phone_home
      xml.PhoneWork spexare.phone_work
      xml.PhoneMobile spexare.phone_mobile
      xml.PhoneOther spexare.phone_other
      xml.EmailAddress spexare.email_address
      xml.BirthDate spexare.birth_date
      xml.SocialSecurityNumber spexare.social_security_number if allowed_to_export_restricted_info(spexare.id)
      xml.ChalmersStudent translate_boolean(spexare.chalmers_student)
      xml.Graduation spexare.graduation
      xml.Deceased translate_boolean(spexare.deceased)
      xml.PublishApproval translate_boolean(spexare.publish_approval) if allowed_to_export_restricted_info(spexare.id)
      xml.WantCirculars translate_boolean(spexare.want_circulars) if allowed_to_export_restricted_info(spexare.id)
      xml.WantEmailCirculars translate_boolean(spexare.want_email_circulars) if allowed_to_export_restricted_info(spexare.id)
      xml.UncertainAddress translate_boolean(spexare.uncertain_address)
      xml.Spouse spexare.spouse.full_name unless !spexare.spouse
      xml.Comment spexare.comment
      xml.Picture spexare.picture? ? (request.ssl? ? 'https://' : 'http://') + Settings['general.site_url'] + spexare.picture.url : ''
      xml.Memberships do
        spexare.memberships.each do |membership|
          xml.Membership(:kind => Membership.kind(membership.kind_id).title) do
            xml.Year membership.year
          end unless membership.kind.nil?
        end
      end
      xml.Activities do
        spexare.activities.each do |activity|
          xml.Spex do
            xml.Year activity.spex.year
            xml.Title activity.spex.spex_detail.title
            xml.Revival translate_boolean(activity.spex.is_revival?)
            xml.Category activity.spex.spex_category.name
          end
          xml.Functions do
            activity.functions.each do |function|
              xml.Function do
                xml.Name function.name
                xml.Category function.function_category.name
                if function.function_category.has_actor
                  xml.Actors do
                    activity.actors.each do |actor|
                      xml.Actor do
                        xml.Role actor.role.blank? ? '' : actor.role 
                        xml.Vocal actor.vocal.nil? ? '' : Actor.vocal(actor.vocal_id).title 
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  def formats
    ['PDF', 'RTF', 'ODT', 'DOCX', 'XML']
  end

  def initial_select
    '/Spexare'
  end

end
