class ActorsController < ApplicationController
  before_filter(:get_function_achievement)

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
  def get_function_achievement
    @function_achievement = FunctionAchievement.find(params[:function_achievement_id])
  end
  
end
