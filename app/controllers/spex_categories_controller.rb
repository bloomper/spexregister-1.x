class SpexCategoriesController < ApplicationController
  inherit_resources
  respond_to :html, :except => [:destroy, :destroy_logo]
  respond_to :js, :only => [:destroy, :destroy_logo]
  respond_to :json, :only => :show
  before_filter :resource, :only => [:destroy_logo]

  def new
    new! do |format|
      format.html { render :action => :new, :layout => false }
    end
  end
  
  def create
    create! do |success, failure|
      success.html { redirect_to filter_url_if_not_compatible_with(current_page, spex_categories_url) }
    end
  end
  
  def update
    update! do |success, failure|
      success.html { redirect_back_or_default spex_categories_url }
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
  
  def destroy_logo
    @spex_category.logo = nil
    if @spex_category.save
      flash.now[:success] = I18n.t('flash.spex_categories.destroy_logo.success')
    else
      flash.now[:failure] = I18n.t('flash.spex_categories.destroy_logo.failure')
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
