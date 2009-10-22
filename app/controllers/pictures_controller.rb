class PicturesController < ApplicationController
  inherit_resources
  belongs_to :spexare, :singleton => true
  
end
