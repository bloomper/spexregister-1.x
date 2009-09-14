require File.dirname(__FILE__) + '/../test_helper'
require 'export_controller'

# Re-raise errors caught by the controller.
class ExportController; def rescue_action(e) raise e end; end

class ExportControllerTest < Test::Unit::TestCase
  fixtures :role_items, :user_items, :spexare_items, :configuration_items

  def setup
    @controller = ExportController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_initiate_export_pdf
    xhr :get, :initiate_export, {:type => 'pdf'}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'exportDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 5
        assert_select 'tr td select option', 'Adressetiketter (3x8 per sida)'
      end
    end
  end

  def test_initiate_export_xls
    xhr :get, :initiate_export, {:type => 'xls'}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'exportDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 5
        assert_select 'tr td select option', 'Lista (inkluderar ej all data)'
      end
    end
  end

  def test_initiate_export_csv
    xhr :get, :initiate_export, {:type => 'csv'}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'exportDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 5
        assert_select 'tr td select option', 'Lista (inkluderar ej all data)'
      end
    end
  end

  def test_initiate_export_rtf
    xhr :get, :initiate_export, {:type => 'rtf'}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'exportDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 5
        assert_select 'tr td select option', 'Adressetiketter (3x8 per sida)'
      end
    end
  end

  def test_initiate_export_xml
    xhr :get, :initiate_export, {:type => 'xml'}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'exportDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 5
        assert_select 'tr td select option', 'Lista (inkluderar all data)'
      end
    end
  end
  
  def test_perform_export_with_simple_search_xml
    get :perform_export, {:type => 'xml', :source => 'simple_search', :template => 'list_complete'}, {:user_item_id => user_items(:test_user).id, :simple_search_query_joins => 'LEFT JOIN link_items ON link_items.spexare_item_id = spexare_items.id', :simple_search_query_conditions => '0 = 0 AND spexare_items.deceased = 0 AND spexare_items.want_circulars = 1 AND spexare_items.publish_approval = 1', :search_sort => { :key => 'last_name', :order => 'asc'}}
    assert_response :success
    assert_match /<FirstName>FirstName1<\/FirstName>/, @response.body
  end
  
  def test_perform_export_with_simple_search_other
    get :perform_export, {:type => 'pdf', :source => 'simple_search', :template => 'labels3x8'}, {:user_item_id => user_items(:test_user).id, :simple_search_query_joins => 'LEFT JOIN link_items ON link_items.spexare_item_id = spexare_items.id', :simple_search_query_conditions => '0 = 0 AND spexare_items.deceased = 0 AND spexare_items.want_circulars = 1 AND spexare_items.publish_approval = 1', :search_sort => { :key => 'last_name', :order => 'asc'}}
    assert_response :success
  end

  def test_perform_export_with_advanced_search_xml
    get :perform_export, {:type => 'xml', :source => 'advanced_search', :template => 'list_complete'}, {:user_item_id => user_items(:test_user).id, :advanced_search_query => '*'}
    assert_response :success
    assert_match /<FirstName>FirstName1<\/FirstName>/, @response.body
  end

  def test_perform_export_with_advanced_search_other
    get :perform_export, {:type => 'pdf', :source => 'advanced_search', :template => 'labels3x8'}, {:user_item_id => user_items(:test_user).id, :advanced_search_query => '*'}
    assert_response :success
  end

  def test_perform_export_with_failure
    get :perform_export, {:type => 'xml', :source => 'simple_search', :template => 'list_complete'}, {:user_item_id => user_items(:test_user).id, :simple_search_query_joins => 'LEFT JOIN link_items ON link_items.spexare_item_id = spexare_items.id', :simple_search_query_conditions => '0 = 0 AND spexare_items.last_name = "dummy"', :search_sort => { :key => 'last_name', :order => 'asc'}}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Oväntat fel inträffade under export.', flash[:error]
  end
end
