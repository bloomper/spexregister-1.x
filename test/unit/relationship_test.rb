require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  
  test "should be ok" do
    relationship = Relationship.create(:spexare => spexare(:spexare_1), :spouse => spexare(:spexare_2))
    assert relationship.valid?, relationship.errors.full_messages.join("\n") 
  end
  
  test "should not save relationship with missing spexare" do
    relationship = Relationship.new(:spexare => nil, :spouse => spexare(:spexare_2))
    assert(!relationship.valid?, "Should not save entry unless spexare has been set")
    assert(relationship.errors.invalid?(:spexare), "Expected an error for missing spexare")
  end
  
  test "should not save relationship with missing spouse" do
    relationship = Relationship.new(:spexare => spexare(:spexare_1), :spouse => nil)
    assert(!relationship.valid?, "Should not save entry unless spouse has been set")
    assert(relationship.errors.invalid?(:spouse), "Expected an error for missing spouse")
  end

end
