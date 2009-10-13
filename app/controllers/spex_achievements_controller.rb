class SpexAchievementsController < ApplicationController
  before_filter(:get_achievement)

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
  def get_achievement
    @achievement = Achievement.find(params[:achievement_id])
  end
  
end
