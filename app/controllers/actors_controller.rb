class ActorsController < ApplicationController
  inherit_resources
  nested_belongs_to :spexare, :activity, :function_activity, :singleton => true
  
end
