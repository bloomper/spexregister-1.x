class AddressDetailListReport < BaseReport
  
  def generate
    xml = Builder::XmlMarkup.new(:indent => 2)
    xml.instruct!
    if session[params[:id].to_sym].is_a? String
      spexare_items = Spexare.find(session[params[:id].to_sym].split(',').collect{ |s| s.to_i }).sort_by { |s| s.send(params[:sort_order]) || '' }
    else
      spexare_items = Spexare.find(fetch_ids_from_solr(session[params[:id].to_sym])).sort_by { |s| s.first_name || '' }
    end
    spexare_items.reverse! if params[:sort_order_descending]
    xml.SpexareItems do
      spexare_items.each do |spexare|
        if params[:include_with_missing_address]
          go_ahead = true
        elsif spexare.street_address.blank? && spexare.postal_code.blank? && spexare.postal_address.blank?
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
          xml.Country spexare.country.blank? ? '' : I18n.t("countries.#{spexare.country}") 
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

  def has_sort_order?
    true
  end

  def formats
    ['PDF', 'XLS', 'ODS', 'CSV', 'HTML', 'XML']
  end

  def initial_select
    '/SpexareItems/Spexare'
  end

end
