class ActorsController < ApplicationController
  before_filter(:get_function_activity)

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
  def get_function_activity
    @function_activity = FunctionActivity.find(params[:function_activity_id])
  end
  
end
