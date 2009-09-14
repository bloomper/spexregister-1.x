require File.dirname(__FILE__) + '/../test_helper'

class ActorItemTest < Test::Unit::TestCase
  fixtures :actor_items

  def test_validation_on_create
    actor_item = ActorItem.new(:role => nil, :vocal => nil)
    assert !actor_item.valid?, actor_item.errors.full_messages
    assert actor_item.errors.invalid?(:vocal), actor_item.errors.full_messages 
    assert_equal "'Stämma' måste vara ett av följande värden: 'B1', 'B2', 'T1', 'T2' eller 'Okänt'.", actor_item.errors.on(:vocal) 
    actor_item.vocal = ActorItem::VOCAL_TYPES[1][1]
    assert actor_item.valid?, actor_item.errors.full_messages
    actor_item.role = 'TestRole'
    assert actor_item.valid?, actor_item.errors.full_messages
    actor_item.vocal = 'Test'
    assert !actor_item.valid?, actor_item.errors.full_messages
  end
end
