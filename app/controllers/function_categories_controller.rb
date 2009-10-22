class FunctionCategoriesController < ApplicationController
  inherit_resources
  actions :index, :show
  belongs_to :function, :singleton => true

end
