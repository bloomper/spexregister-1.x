class SpexActivitiesController < ApplicationController
  inherit_resources
  respond_to :html
  nested_belongs_to :spexare, :activity, :singleton => true
  
end
