class TagSearchController < ApplicationController
  inherit_resources
  respond_to :html, :only => [:new, :index, :destroy]
  defaults :resource_class => Spexare, :collection_name => 'tag_search_result', :route_collection_name => 'tag_search_index', :route_instance_name => 'spexare'

  helper_method :get_available_reports

  def new
    session[:latest_tag_search_query] = nil
    session[:latest_tag_search_query_ids] = nil
    @tags = Tag.tags_count
  end

  def destroy
    session[:latest_tag_search_query] = nil
    session[:latest_tag_search_query_ids] = nil
    redirect_to new_tag_search_url
  end

  protected
  def collection
    params[:tag_search] ||= 'last_name'
    tag_search_result_all = Spexare.find(:all, :select => 'DISTINCT spexare.id, spexare.last_name, spexare.first_name, spexare.nick_name', :conditions => ['taggings.tag_id = ? and (spexare.publish_approval = ? or spexare.publish_approval = ?)', params[:id], true, current_user_is_admin? ? false : true], :joins => 'left join taggings on taggings.spexare_id = spexare.id', :order => params[:order])
    @tag_search_result = tag_search_result_all.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)

    session[:latest_tag_search_query] = params
    session[:latest_tag_search_query_ids] = tag_search_result_all.map(&:id).join(',')
  end

  private
  def get_available_reports
    [{:key => 'address_labels', :title => t('views.report.address_labels.title')}, {:key => 'detail_list', :title => t('views.report.detail_list.title')}, {:key => 'email_address_detail_list', :title => t('views.report.email_address_detail_list.title')}, {:key => 'address_detail_list', :title => t('views.report.address_detail_list.title')}]
  end

end
