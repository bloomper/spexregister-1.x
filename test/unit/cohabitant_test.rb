require 'test_helper'

class CohabitantTest < ActiveSupport::TestCase
  
  test "should be ok" do
    cohabitant = Cohabitant.create(:spexare => spexare(:spexare_1), :spexare_cohabitant => spexare(:spexare_2))
    assert cohabitant.valid?, cohabitant.errors.full_messages.join("\n") 
  end
  
  test "should not save cohabitant with missing spexare" do
    cohabitant = Cohabitant.new(:spexare => nil, :spexare_cohabitant => spexare(:spexare_2))
    assert(!cohabitant.valid?, "Should not save entry unless spexare has been set")
    assert(cohabitant.errors.invalid?(:spexare), "Expected an error for missing spexare")
  end
  
  test "should not save cohabitant with missing cohabitant spexare" do
    cohabitant = Cohabitant.new(:spexare => spexare(:spexare_1), :spexare_cohabitant => nil)
    assert(!cohabitant.valid?, "Should not save entry unless cohabitant spexare has been set")
    assert(cohabitant.errors.invalid?(:spexare_cohabitant), "Expected an error for missing cohabitant spexare")
  end

end
