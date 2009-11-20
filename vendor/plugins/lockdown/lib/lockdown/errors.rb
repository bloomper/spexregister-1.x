module Lockdown
  class InvalidRuleAssignment < StandardError; end

  class InvalidRuleContext < StandardError; end

  class PermissionScopeCollision < StandardError; end

  class InvalidPermissionAssignment < StandardError; end
end
