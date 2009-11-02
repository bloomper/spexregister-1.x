class FunctionActivitiesController < ApplicationController
  inherit_resources
  respond_to :html
  nested_belongs_to :spexare, :activity
  
end
