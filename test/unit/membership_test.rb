require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  
  test "should be ok" do
    membership = Membership.create(:kind => :fgv, :year => '2098', :spexare => spexare(:spexare_1))
    assert membership.valid?, membership.errors.full_messages.join("\n") 
  end
  
  test "should not save membership with missing kind" do
    membership = Membership.new(:kind => nil, :year => '2098', :spexare => spexare(:spexare_1))
    assert(!membership.valid?, "Should not save entry unless kind has been set")
    assert(membership.errors.invalid?(:kind_id), "Expected an error for missing kind")
  end
  
  test "should not save membership with missing year" do
    membership = Membership.new(:kind => :fgv, :year => nil, :spexare => spexare(:spexare_1))
    assert(!membership.valid?, "Should not save entry unless year has been set")
    assert(membership.errors.invalid?(:year), "Expected an error for missing year")
  end
  
  test "should not save membership with invalid kind" do
    membership = Membership.new(:kind_id => 99, :year => '2098', :spexare => spexare(:spexare_1))
    assert(!membership.valid?, "Should not save entry unless kind has been set to a legal value")
    assert(membership.errors.invalid?(:kind_id), "Expected an error for invalid kind")
  end
  
  test "should not save membership with invalid year" do
    membership = Membership.new(:kind => :fgv, :year => 'invalidyear', :spexare => spexare(:spexare_1))
    assert(!membership.valid?, "Should not save entry unless a valid year has been set")
    assert(membership.errors.invalid?(:year), "Expected an error for invalid year")
  end
  
end
