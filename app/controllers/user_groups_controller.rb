class UserGroupsController < ApplicationController
  inherit_resources
  respond_to :html
  actions :all, :except => [ :new, :create, :show, :index, :edit, :update, :destroy ]
  belongs_to :user
  before_filter :resource, :only => [:select, :selected, :available, :remove]
  
  def available
    set_available_user_groups
    render :layout => false
  end
  
  def selected 
    @user_groups = @user.user_groups
  end
  
  def remove
    @user.user_groups.delete(@user_group)
    @user.save
    @user_groups = @user.user_groups
    set_available_user_groups
    render :action => 'selected', :layout => false
  end
  
  def select
    @user.user_groups << UserGroup.find_by_id(params[:id])
    @user.save
    @user_groups = @user.user_groups
    set_available_user_groups
    render :action => 'selected', :layout => false
  end

  protected
  def resource
    @user_group ||= end_of_association_chain.find_by_id(params[:id])
  end  

  def collection
    base_scope = end_of_association_chain
    @search = base_scope.search(params[:search])
    @search.order ||= "ascend_by_name"
    
    @user_groups ||= @search.paginate(:page => params[:page], :per_page => ApplicationConfig.entities_per_page)
  end

  private 
  def set_available_user_groups
    @available_user_groups = UserGroup.all
    selected_user_groups = []
    @user.user_groups.each do |user_group| 
      selected_user_groups << user_group
    end
    @available_user_groups.delete_if {|user_group| selected_user_groups.include? user_group}
  end
  
end
