require File.dirname(__FILE__) + '/../test_helper'
require 'search_controller'

# Re-raise errors caught by the controller.
class SearchController; def rescue_action(e) raise e end; end

class SearchControllerTest < Test::Unit::TestCase
  fixtures :role_items, :user_items, :spexare_items, :spex_items, :spex_category_items, :function_items, :function_category_items, :configuration_items

  def setup
    @controller = SearchController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_simple_search
    post :simple_search, {:nick_name => '', :first_name => '', :last_name => '', :spex_category_item => {:id => '-1'}, :function_category_item => {:id => '-1'}}, {:user_item_id => user_items(:test_user).id}
    assert_redirected_to @controller.url_for(:controller => '/search', :action => :simple_search_result)
    assert_equal 'LEFT JOIN link_items ON link_items.spexare_item_id = spexare_items.id ', session[:simple_search_query_joins]
    assert_equal '0 = 0 AND spexare_items.deceased = 0 AND spexare_items.want_circulars = 1 AND spexare_items.publish_approval = 1 ', session[:simple_search_query_conditions]
  end
  
  def test_simple_search_result
    get :simple_search_result, {}, {:user_item_id => user_items(:test_user).id, :simple_search_query_joins => 'LEFT JOIN link_items ON link_items.spexare_item_id = spexare_items.id', :simple_search_query_conditions => '0 = 0 AND spexare_items.deceased = 0 AND spexare_items.want_circulars = 1 AND spexare_items.publish_approval = 1'}
    assert_template 'simple_search_result'
    assert_select 'div#titleContainer', 'Sökresultat...'
    assert_select 'div#spexareItemListDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 4
        assert_select 'tr td', spexare_items(:spexare_item_1).first_name
      end
    end
  end

  def test_simple_search_result_with_invalid_query
    get :simple_search_result, {}, {:user_item_id => user_items(:test_user).id, :simple_search_query_joins => nil, :simple_search_query_conditions => nil}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Ogiltligt sökuttryck.', flash[:error]
  end

  def test_advanced_search
    post :advanced_search, {:query => '*'}, {:user_item_id => user_items(:test_user).id}
    assert_redirected_to @controller.url_for(:controller => '/search', :action => :advanced_search_result)
    assert_equal '*', session[:advanced_search_query]
  end
  
  def test_advanced_search_result
    get :advanced_search_result, {}, {:user_item_id => user_items(:test_user).id, :advanced_search_query => '*'}
    assert_template 'advanced_search_result'
    assert_select 'div#titleContainer', 'Sökresultat...'
    assert_select 'div#spexareItemListDialog' do
      assert_select 'table' do
        assert_select 'tr', :count => 4
        assert_select 'tr td', spexare_items(:spexare_item_1).first_name
      end
    end
  end

  def test_advanced_search_result_with_invalid_query
    get :advanced_search_result, {}, {:user_item_id => user_items(:test_user).id, :advanced_search_query => nil}
    assert_redirected_to @controller.url_for(:controller => '/home', :action => :index)
    assert_equal 'Ogiltligt sökuttryck.', flash[:error]
  end

  def test_find_spex_years_by_category
    xhr :get, :find_spex_years_by_category, {:spex_category_item_id => spex_category_items(:test_category_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select 'select' do
      assert_select 'option', :count => 3
    end
  end

  def test_find_spex_titles_by_category
    xhr :get, :find_spex_titles_by_category, {:spex_category_item_id => spex_category_items(:test_category_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select 'select' do
      assert_select 'option', :count => 3
    end
  end

  def test_find_functions_by_category
    xhr :get, :find_functions_by_category, {:function_category_item_id => function_category_items(:test_category_1).id}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select 'select' do
      assert_select 'option', :count => 2
    end
  end

  def test_advanced_search_help_how_open
    xhr :get, :advanced_search_help_how, {:operation => 'open'}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'advancedSearchHelpHow'
    assert_select 'table'
  end

  def test_advanced_search_help_how_close
    xhr :get, :advanced_search_help_how, {:operation => 'close'}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'advancedSearchHelpHow'
  end

  def test_advanced_search_help_fields_open
    xhr :get, :advanced_search_help_fields, {:operation => 'open'}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'advancedSearchHelpFields'
    assert_select 'table'
  end

  def test_advanced_search_help_fields_close
    xhr :get, :advanced_search_help_fields, {:operation => 'close'}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'advancedSearchHelpFields'
  end

  def test_advanced_search_help_examples_open
    xhr :get, :advanced_search_help_examples, {:operation => 'open'}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'advancedSearchHelpExamples'
    assert_select 'table'
  end

  def test_advanced_search_help_examples_close
    xhr :get, :advanced_search_help_examples, {:operation => 'close'}, {:user_item_id => user_items(:test_user).id}
    assert_response :success
    assert_select_rjs 'advancedSearchHelpExamples'
  end
end
