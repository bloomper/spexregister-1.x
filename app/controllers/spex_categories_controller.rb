class SpexCategoriesController < ApplicationController
  inherit_resources
  respond_to :html, :except => :destroy
  respond_to :js, :only => :destroy
  respond_to :json, :only => :show
  
  def new
    new! do |format|
      format.html { render :action => :new, :layout => false }
    end
  end
  
  def create
    create! do |success, failure|
      success.html { redirect_to spex_categories_url }
    end
  end
  
  def update
    update! do |success, failure|
      success.html { redirect_to spex_categories_url }
    end
  end
  
  def show
    show! do |format|
      format.json { render :json => @spex_category.to_json(:only => [:id, :name, :first_year]) }
    end
  end
  
  def destroy
    destroy! do |success, failure|
      failure.js { render :status => 409 }
    end
  end
  
  protected
  def resource
    @spex_category ||= end_of_association_chain.find_by_id(params[:id])
  end  
  
  def collection
    base_scope = end_of_association_chain
    @search = base_scope.search(params[:search])
    @search.order ||= "ascend_by_name"
    
    @spex_categories ||= @search.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
  end
  
end
