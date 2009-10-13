class PostersController < ApplicationController
  before_filter(:get_spex)
  
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
  def get_spex
    @spex = Spex.find(params[:spex_id])
  end

end
