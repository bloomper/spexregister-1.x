class SpexActivitiesController < ApplicationController
  inherit_resources
  nested_belongs_to :spexare, :activity, :singleton => true
  
end
