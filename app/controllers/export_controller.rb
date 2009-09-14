require 'csv'

class ExportController < BaseController
  include ReportGenerator

  def initiate_export
    if params[:type] == 'pdf'
      @options = [['Adressetiketter (3x8 per sida)', 'labels3x8'], ['Komprimerad adresslista', 'condensed_address_list'], ['Komplett information (1 per sida)', 'one_pager_complete'], ['Strecklista', 'miscellaneous_list']]
    elsif params[:type] == 'xls'
      @options = [['Lista (inkluderar ej all data)', 'list_non_complete'], ['Komprimerad adresslista', 'condensed_address_list'], ['Strecklista', 'miscellaneous_list']]
    elsif params[:type] == 'csv'
      @options = [['Lista (inkluderar ej all data)', 'list_non_complete'], ['Komprimerad adresslista', 'condensed_address_list'], ['Maildistributionslista', 'email_distribution_list'], ['Strecklista', 'miscellaneous_list']]
    elsif params[:type] == 'rtf'
      @options = [['Adressetiketter (3x8 per sida)', 'labels3x8'], ['Komplett information (1 per sida)', 'one_pager_complete']]
    elsif params[:type] == 'xml'
      @options = [['Lista (inkluderar all data)', 'list_complete']]
    elsif params[:type] == 'email'
      # do nothing
    end
  end

  def perform_export
    if params[:source] == 'simple_search'
      if session[:search_sort].nil?
        @spexare_items = SpexareItem.find(:all, :page => {:size => get_configuration_item(ConfigurationItem::EXPORT_PAGE_SIZE).to_i, :auto => true}, :select => 'DISTINCT spexare_items.*', :joins => session[:simple_search_query_joins], :conditions => session[:simple_search_query_conditions], :include => :link_items)
      else
        @spexare_items = SpexareItem.find(:all, :page => {:size => get_configuration_item(ConfigurationItem::EXPORT_PAGE_SIZE).to_i, :auto => true}, :order => "#{session[:search_sort][:key]} #{session[:search_sort][:order]}", :select => 'DISTINCT spexare_items.*', :joins => session[:simple_search_query_joins], :conditions => session[:simple_search_query_conditions], :include => :link_items)
      end
    elsif params[:source] == 'advanced_search'
      @spexare_items = SpexareItem.full_text_search(session[:advanced_search_query], {:size => get_configuration_item(ConfigurationItem::EXPORT_PAGE_SIZE).to_i, :auto => true})
    end
    @include_uncertain_addresses = true if params[:include_uncertain_addresses]
    @include_only_one_in_a_relation = true if params[:include_only_one_in_a_relation]
    if !@spexare_items.nil?
      if params[:template] != 'email_distribution_list'
        generated_string = render_to_string(:template => "export/#{params[:template]}", :layout => false);
        if params[:type] != 'xml'
          generate_report(generated_string, '/SpexareItems/SpexareItem', params[:template], 'export', params[:type])
        else
          send_data(generated_string, :filename => 'export.xml', :type => 'text/xml', :disposition => 'attachment')
        end
      else
        send_data(generate_csv.read, :type => 'text/csv; charset=iso-8859-1; header=present', :filename => 'export.csv')
      end
    else
      redirect_to_index('Oväntat fel inträffade under export.', true)
    end
  end
  
  def perform_mail_export
    if request.xhr?
      if params[:sender_address].blank?
        render :partial => 'shared/ajax_error', :locals => { :error => "Du måste ange adress för avsändare." }
        return
      end
      if params[:subject].blank?
        render :partial => 'shared/ajax_error', :locals => { :error => "Du måste ange ämne." }
        return
      end
      if params[:mail_body].blank?
        render :partial => 'shared/ajax_error', :locals => { :error => "Du måste ange meddelande." }
        return
      end
      if params[:source] == 'simple_search'
        if session[:search_sort].nil?
          @spexare_items = SpexareItem.find(:all, :page => {:size => get_configuration_item(ConfigurationItem::EXPORT_PAGE_SIZE).to_i, :auto => true}, :select => 'DISTINCT spexare_items.*', :joins => session[:simple_search_query_joins], :conditions => session[:simple_search_query_conditions], :include => :link_items)
        else
          @spexare_items = SpexareItem.find(:all, :page => {:size => get_configuration_item(ConfigurationItem::EXPORT_PAGE_SIZE).to_i, :auto => true}, :order => "#{session[:search_sort][:key]} #{session[:search_sort][:order]}", :select => 'DISTINCT spexare_items.*', :joins => session[:simple_search_query_joins], :conditions => session[:simple_search_query_conditions], :include => :link_items)
        end
      elsif params[:source] == 'advanced_search'
        @spexare_items = SpexareItem.full_text_search(session[:advanced_search_query], {:size => get_configuration_item(ConfigurationItem::EXPORT_PAGE_SIZE).to_i, :auto => true})
      end
      @include_uncertain_addresses = true if params[:include_uncertain_addresses]
      @include_only_one_in_a_relation = true if params[:include_only_one_in_a_relation]
      if !@spexare_items.nil?
        session[:job_key] = MiddleMan.new_worker(:class => :mailman_worker, :args => { :sender_address => params[:sender_address], :send_result => params[:send_result], :mail_body => params[:mail_body], :subject => params[:subject], :recipients => generate_csv.read, :admin_mail_address => get_configuration_item(ConfigurationItem::ADMIN_MAIL_ADDRESS) })
        render :update do |page|
          page.hide 'errorPane'
          page.hide 'messagePane'
          page.replace_html 'progressPoller', :partial => 'shared/progressPoller'
          page.call('Spexregister.progressPercent', 'progressIndicator', '0')
          page.show 'progressIndicator'
        end
      end
    end
  end

  def hide_mail_export
    if request.xhr?
      render :update do |page|
        page.visual_effect :fade, 'mailExportDialog', :afterFinish => "function() { Spexregister.killRichTextEditor('mail_body') }"
      end
    end
  end

  private
    def generate_csv
      generated_string = StringIO.new
      CSV::Writer.generate(generated_string, ',', ',') do |csv|
        related_cache = []
        user_item = get_user_from_session
        @spexare_items.each do |spexare_item|
          do_print_uncertain = true unless spexare_item.uncertain_address && !@include_uncertain_addresses
          if @include_only_one_in_a_relation
            if !spexare_item.related_spexare_items.nil? && spexare_item.related_spexare_items.size > 0
              if !related_cache.include?(spexare_item.id)
                do_print_related = true
                related_cache << spexare_item.related_spexare_items[0].id
              end
            end
          else
            do_print_related = true
          end
          if do_print_uncertain && (do_print_related || spexare_item.related_spexare_items.nil? || spexare_item.related_spexare_items.size == 0)
            csv << [spexare_item.email_address] if !spexare_item.email_address.blank?
          end
        end
      end
      generated_string.rewind
      return generated_string
    end
end
