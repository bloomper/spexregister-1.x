class FunctionsController < ApplicationController
  inherit_resources
  respond_to :html, :except => :destroy
  respond_to :js, :only => :destroy
  respond_to :json, :only => :index
  
  def new
    new! do |format|
      format.html { render :action => :new, :layout => false }
    end
  end
  
  def create
    create! do |success, failure|
      success.html { redirect_to filter_url_if_not_compatible_with(current_page, functions_url) }
    end
  end
  
  def update
    update! do |success, failure|
      success.html { redirect_back_or_default functions_url }
    end
  end
  
  def index
    index! do |format|
      format.json { render :json => @functions.to_json(:only => [:id, :name]) }
    end
  end
  
  def destroy
    destroy! do |success, failure|
      failure.js { render :status => 409 }
    end
  end

  protected
  def resource
    @function ||= end_of_association_chain.find_by_id(params[:id])
  end  
  
  def collection
    base_scope = end_of_association_chain
    @search = base_scope.search(params[:search])
    @search.order ||= "ascend_by_name"
    
    if params[:format] != 'json'
      @functions ||= @search.paginate(:page => params[:page], :per_page => params[:per_page] || ApplicationConfig.entities_per_page)
    else
      @functions ||= @search.all
    end
  end
  
end
