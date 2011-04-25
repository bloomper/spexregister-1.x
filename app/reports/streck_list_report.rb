class StreckListReport < BaseReport
  
  def generate
    xml = Builder::XmlMarkup.new(:indent => 2)
    xml.instruct!
    spexare_items = Spexare.by_spex(params[:id]).sort_by { |s| s.first_name || '' }
    spexare_items.reverse! if params[:sort_order_descending]
    xml.SpexareItems do
      spexare_items.each do |spexare|
        xml.Spexare do
          xml.FullName spexare.full_name
        end
      end
    end
  end

  def has_sort_order?
    true
  end

  def formats
    ['PDF', 'RTF', 'ODT', 'DOCX', 'XLS', 'ODS', 'CSV', 'HTML', 'XML']
  end

  def initial_select
    '/SpexareItems/Spexare'
  end

end
