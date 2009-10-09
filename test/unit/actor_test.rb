require 'test_helper'

class ActorTest < ActiveSupport::TestCase
  
  test "should be ok" do
    actor = Actor.create(:role => 'Role', :vocal => :unknown, :achievement => achievements(:achievement_1))
    assert actor.valid?, actor.errors.full_messages.join("\n") 
  end
  
  test "should be ok with no values" do
    actor = Actor.new(:role => nil, :vocal => nil, :achievement => achievements(:achievement_1))
    assert actor.valid?, actor.errors.full_messages.join("\n") 
  end

  test "should not save actor with invalid vocal" do
    actor = Actor.new(:role => 'Role', :vocal_id => 99, :achievement => achievements(:achievement_1))
    assert(!actor.valid?, "Should not save entry unless vocal has been set to a legal value")
    assert(actor.errors.invalid?(:vocal_id), "Expected an error for invalid vocal")
  end
  
end
