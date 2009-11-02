class PermissionsController < ApplicationController
  inherit_resources
  respond_to :html
  actions :index, :show
  nested_belongs_to :user, :user_group

end
