class FunctionActivitiesController < ApplicationController
  before_filter(:get_activity)

  def index
  end
  
  def show
  end
  
  def new
  end
  
  def edit
  end
  
  def create
  end
  
  def update
  end
  
  def destroy
  end

  private
  def get_activity
    @activity = Activity.find(params[:activity_id])
  end
  
end
