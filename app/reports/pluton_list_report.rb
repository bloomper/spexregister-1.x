class PlutonListReport < BaseReport
  
  def generate
    xml = Builder::XmlMarkup.new(:indent => 2)
    xml.instruct!
    spex = Spex.find(params[:id])
    xml.PlutonList do
      xml.Header do
        xml.Title Settings["reports.pluton_list_header_title_#{spex.spex_category.id}"]
        xml.SupplementalLine1 Settings["reports.pluton_list_header_supplemental_line_1_#{spex.spex_category.id}"]
        xml.SupplementalLine2 Settings["reports.pluton_list_header_supplemental_line_2_#{spex.spex_category.id}"]
        xml.SupplementalLine3 Settings["reports.pluton_list_header_supplemental_line_3_#{spex.spex_category.id}"]
      end
      order = Settings["reports.pluton_list_order_#{spex.spex_category.id}"]
      xml.SpexareItems do
        order.split(',').each do |function_id|
          function = Function.find(function_id)
          spexare_items = Spexare.by_spex_and_function(params[:id], function_id)
          spexare_items.each do |spexare|
            xml.Spexare do
              xml.Role function.name
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
    end
  end

  def formats
    ['PDF', 'RTF', 'ODT', 'DOCX', 'HTML', 'XML']
  end

  def initial_select
    '/PlutonList/Header'
  end

end
