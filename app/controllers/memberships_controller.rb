class MembershipsController < ApplicationController
  inherit_resources
  respond_to :html
  belongs_to :spexare
  has_scope :by_kind
  
end
