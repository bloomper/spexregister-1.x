class SpexCategoriesController < ApplicationController
  inherit_resources
  actions :index, :show
  belongs_to :spex, :singleton => true

end
