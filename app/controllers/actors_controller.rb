class ActorsController < ApplicationController
  inherit_resources
  respond_to :html
  nested_belongs_to :spexare, :activity, :function_activity, :singleton => true
  
end
