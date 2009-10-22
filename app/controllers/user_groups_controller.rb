class UserGroupsController < ApplicationController
  inherit_resources
  actions :index, :show
  belongs_to :user

end
