class ActivitiesController < ApplicationController
  inherit_resources
  respond_to :html
  belongs_to :spexare
  
end
