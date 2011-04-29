class TaggingsController < ApplicationController
  inherit_resources
  actions :all, :except => [:show, :edit, :update]
  respond_to :html
  belongs_to :spexare
  before_filter :resource, :only => [:selected]
  
  def new
    new! do |format|
      set_available_tags
      format.html { render :layout => false }
    end
  end
  
  def create
    create! do |format|
      @taggings = @spexare.taggings.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
      flash.discard
      format.html { render :action => 'selected', :layout => false }
    end
  end
  
  def selected
    @taggings = @spexare.taggings.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
  end
  
  def destroy
    destroy! do |format|
      @taggings = @spexare.taggings.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
      flash.discard
      format.html { render :action => 'selected', :layout => false }
    end
  end
  
  def index
    index! do
      @taggings = @spexare.taggings.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
    end
  end
  
  protected
  def resource
    @tagging ||= end_of_association_chain.find_by_id(params[:id])
  end  
  
  def collection
    @taggings ||= end_of_association_chain.find(:all).paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
  end

  def is_storeable_location?(uri)
    false
  end

  def show_search_result_back_links?
    if !previous_page.match('search') && !previous_page.match('advanced_search')
      true
    end
  end

  private 
  def set_available_tags
    @available_tags = Tag.find(:all).dup
    @spexare.taggings.each do |tagging|
      @available_tags.delete_if {|tag| tagging.tag == tag}
    end
  end
  
end
