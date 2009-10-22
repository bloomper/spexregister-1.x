class PermissionsController < ApplicationController
  inherit_resources
  actions :index, :show
  nested_belongs_to :user, :user_group

end
