class MembershipsController < ApplicationController
  before_filter(:get_spexare)
  
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
  def get_spexare
    @spexare = Spexare.find(params[:spexare_id])
  end
  
end
