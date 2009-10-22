class FunctionActivitiesController < ApplicationController
  inherit_resources
  nested_belongs_to :spexare, :activity
  
end
