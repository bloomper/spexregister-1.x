class MembershipsController < ApplicationController
  inherit_resources
  belongs_to :spexare
  has_scope :by_kind
  
end
