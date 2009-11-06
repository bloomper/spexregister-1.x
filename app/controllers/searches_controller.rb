class SearchesController < ApplicationController

  def new
    @search = Search.new
    logger.fatal @search
  end

  def create
  end

end
