require File.dirname(__FILE__) + '/../test_helper'

class RoleItemTest < Test::Unit::TestCase
  fixtures :role_items

  def test_validation_on_create
    role_item = RoleItem.new(:name => nil, :description => nil)
    assert !role_item.valid?, role_item.errors.full_messages
    assert role_item.errors.invalid?(:name), role_item.errors.full_messages
    assert_equal "Du måste ange 'Namn'.", role_item.errors.on(:name) 
    assert role_item.errors.invalid?(:description), role_item.errors.full_messages
    assert_equal "Du måste ange 'Beskrivning'.", role_item.errors.on(:description) 
    role_item.name = 'TestName'
    assert !role_item.valid?, role_item.errors.full_messages
    role_item.description = 'TestDescription'
    assert role_item.valid?, role_item.errors.full_messages
    role_item.save

    another_role_item = RoleItem.new(:name => 'TestName', :description => 'TestDescription')
    assert !another_role_item.valid?, another_role_item.errors.full_messages
    assert another_role_item.errors.invalid?(:name), another_role_item.errors.full_messages
    assert_equal "Angivet 'Namn' existerar redan.", another_role_item.errors.on(:name) 
    another_role_item.name = 'TestName2'
    assert !another_role_item.valid?, another_role_item.errors.full_messages
    assert another_role_item.errors.invalid?(:description), another_role_item.errors.full_messages
    assert_equal "Angiven 'Beskrivning' existerar redan.", another_role_item.errors.on(:description) 
    another_role_item.description = 'TestDescription2'
    assert another_role_item.valid?, another_role_item.errors.full_messages
  end
end
