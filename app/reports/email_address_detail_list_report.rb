class EmailAddressDetailListReport < BaseReport
  
  def generate
    xml = Builder::XmlMarkup.new(:indent => 2)
    xml.instruct!
    if session[params[:id].to_sym].is_a? String
      spexare_items = Spexare.find(session[params[:id].to_sym].split(',').collect{ |s| s.to_i }).sort_by { |s| s.email_address || '' }
    else
      spexare_items = Spexare.find(fetch_ids_from_solr(session[params[:id].to_sym])).sort_by { |s| s.first_name || '' }
    end
    spexare_items.reverse! if params[:sort_order_descending]
    xml.SpexareItems do
      spexare_items.each do |spexare|
        if params[:include_with_missing_email_address]
          go_ahead = true
        elsif spexare.email_address.blank?
          go_ahead = false
        else
          go_ahead = true
        end
        xml.Spexare do
          xml.FullName spexare.full_name
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
