class SpexCategoriesController < ApplicationController
  inherit_resources
  belongs_to :spex, :singleton => true

end
