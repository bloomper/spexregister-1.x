class UserGroupsController < ApplicationController
  inherit_resources
  respond_to :html
  actions :index, :show
  belongs_to :user

end
