require 'test_helper'

class SpexareTest < ActiveSupport::TestCase
  include ActionController::TestProcess

  test "should be ok" do
    spexare = Spexare.create(:last_name => Time.now, :first_name => Time.now)
    assert spexare.valid?, spexare.errors.full_messages.join("\n") 
  end

  test "should be ok with social security number" do
    spexare = Spexare.create(:last_name => Time.now, :first_name => Time.now, :social_security_number => '1234')
    assert spexare.valid?, spexare.errors.full_messages.join("\n") 
  end

  test "should be ok with jpg picture" do
    picture = fixture_file_upload('files/jpgFile.jpg', 'image/jpeg', :binary)
    spexare = Spexare.create(:last_name => Time.now, :first_name => Time.now, :picture => picture)
    assert spexare.valid?, spexare.errors.full_messages.join("\n") 
  end
  
  test "should be ok with gif picture" do
    picture = fixture_file_upload('files/gifFile.gif', 'image/gif', :binary)
    spexare = Spexare.create(:last_name => Time.now, :first_name => Time.now, :picture => picture)
    assert spexare.valid?, spexare.errors.full_messages.join("\n") 
  end
  
  test "should be ok with png picture" do
    picture = fixture_file_upload('files/pngFile.png', 'image/png', :binary)
    spexare = Spexare.create(:last_name => Time.now, :first_name => Time.now, :picture => picture)
    assert spexare.valid?, spexare.errors.full_messages.join("\n") 
  end

  test "should not save spexare with no last name" do
    spexare = Spexare.new(:last_name => nil, :first_name => Time.now)
    assert(!spexare.valid?, "Should not save entry unless last name has been set")
    assert(spexare.errors.invalid?(:last_name), "Expected an error for missing last name")
  end

  test "should not save spexare with no first name" do
    spexare = Spexare.new(:last_name => Time.now, :first_name => nil)
    assert(!spexare.valid?, "Should not save entry unless first name has been set")
    assert(spexare.errors.invalid?(:first_name), "Expected an error for missing first name")
  end

  test "should not save spexare with invalid social security number" do
    spexare = Spexare.new(:last_name => Time.now, :first_name => Time.now, :social_security_number => 'invalid')
    assert(!spexare.valid?, "Should not save entry unless a valid social security number has been set")
    assert(spexare.errors.invalid?(:social_security_number), "Expected an error for invalid social security number")
  end

  test "should not save spexare with too large picture" do
    picture = fixture_file_upload('files/largeFile.jpg', 'image/jpg', :binary)
    spexare = Spexare.create(:last_name => Time.now, :first_name => Time.now, :picture => picture)
    assert(!spexare.valid?, "Should not save entry if an invalid picture has been set")
    assert(spexare.errors.invalid?(:picture), "Expected an error for invalid picture")
  end
  
  test "should not save spexare with invalid picture" do
    picture = fixture_file_upload('files/invalidFileType.txt', 'text/plain', :binary)
    spexare = Spexare.create(:last_name => Time.now, :first_name => Time.now, :picture => picture)
    assert(!spexare.valid?, "Should not save entry if an invalid picture has been set")
    assert(spexare.errors.invalid?(:picture), "Expected an error for invalid picture")
  end

  test "should be ok with relationships" do
    spexare = Spexare.create(:last_name => Time.now, :first_name => Time.now)
    activity = Activity.create(:spexare => spexare)
    spexare.activities << activity
    spex_activity = SpexActivity.create(:activity => activity, :spex => spex(:spex_1))
    function_activity = FunctionActivity.create(:activity => activity, :function => functions(:function))
    assert(1, spexare.activities.size)
    assert(spex(:spex_1), spexare.activities.first.spex)
    assert(1, spexare.activities.first.functions.size)
    assert(functions(:function), spexare.activities.first.functions.first)
    spexare.destroy
    assert(Spex.exists?(:year => spex(:spex_1).year))
    assert(Function.exists?(:name => functions(:function).name))
  end

end
