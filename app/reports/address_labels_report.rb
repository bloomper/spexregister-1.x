class AddressLabelsReport < BaseReport
  
  def generate
    xml = Builder::XmlMarkup.new(:indent => 2)
    xml.instruct!
    spexare_items = Spexare.find(session[params[:id].to_sym].split(',').collect{ |s| s.to_i }).sort_by { |s| s.first_name || '' }
    spexare_items.reverse! if params[:sort_order_descending]
    spouses = Array.new
    combined_full_name = ''
    xml.SpexareItems do
      spexare_items.each do |spexare|
        if params[:include_with_missing_address]
          go_ahead = true
        elsif spexare.street_address.blank? && spexare.postal_code.blank? && spexare.postal_address.blank?
          go_ahead = false
        else
          go_ahead = true
        end
        if params[:merge_related_with_same_address]
          if spouses.include? spexare.id
            go_ahead = false
          elsif spexare.spouse && spexare.street_address == spexare.spouse.street_address && spexare.postal_code == spexare.spouse.postal_code && spexare.postal_address == spexare.spouse.postal_address
            combined_full_name = spexare.full_name_without_nickname + ' & ' + spexare.spouse.full_name_without_nickname
            spouses.push spexare.spouse.id
          else
            combined_full_name = ''
          end
        end
        xml.Spexare do
          xml.FullName params[:merge_related_with_same_address] && !combined_full_name.blank? ? combined_full_name : spexare.full_name_without_nickname
          xml.StreetAddress spexare.street_address
          xml.PostalCode spexare.postal_code
          xml.PostalAddress spexare.postal_address
          xml.Country((spexare.country.blank? || spexare.country == ApplicationConfig.default_country) ? '' : I18n.t("countries.#{spexare.country}")) 
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
    ['PDF', 'RTF', 'ODT', 'DOCX', 'HTML', 'XML']
  end

  def initial_select
    '/SpexareItems/Spexare'
  end

end
