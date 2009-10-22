class PostersController < ApplicationController
  inherit_resources
  belongs_to :spex, :singleton => true

end
