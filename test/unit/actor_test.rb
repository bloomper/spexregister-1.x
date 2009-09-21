require 'test_helper'

class ActorTest < ActiveSupport::TestCase
  fixtures :actors, :links
  
  def test_ok
    actor = Actor.create(:role => 'Role', :vocal => :unknown, :link => links(:link_1))
    assert actor.valid?, actor.errors.full_messages.join("\n") 
  end
  
  def test_ok_with_no_values
    actor = Actor.new(:role => nil, :vocal => nil, :link => links(:link_1))
    assert actor.valid?, actor.errors.full_messages.join("\n") 
  end

  def test_should_not_save_actor_with_invalid_vocal
    actor = Actor.new(:role => 'Role', :vocal_id => 99, :link => links(:link_1))
    assert(!actor.valid?, "Should not save entry unless vocal has been set to a legal value")
    assert(actor.errors.invalid?(:vocal_id), "Expected an error for invalid vocal")
  end
  
end
