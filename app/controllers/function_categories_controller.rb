class FunctionCategoriesController < ApplicationController
  inherit_resources
  belongs_to :function, :singleton => true

end
