class BaseReport

  def has_conditions?
    false
  end
  
  def has_sort_order?
    false
  end

  def allowed_to_export_restricted_info(id = nil)
    @is_admin || (@user.spexare.nil? ? -1 : @user.spexare.id) == id
  end
  
  def set_user(user, is_admin)
    @user = user
    @is_admin = is_admin
  end
  
  def formats
    []
  end

  def translate_boolean(value)
    value ? I18n.t('views.base.yes') : I18n.t('views.base.no')
  end

  def fetch_ids_from_solr(query)
    solr = RSolr.connect(:url => Settings['full_text_and_advanced_search.search_engine_url'])
    response = solr.post :select, :data => session[params[:id].to_sym]
    [].tap do |ids|
      response['response']['docs'].each do |doc|
         ids << doc['id'].match(/([^ ]+) (.+)/)[1..2][1].to_i
      end
    end
  end

end
