class SignupsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    # TODO
    # Validation
    # What to do with email and other extra information that is needed at this stage?
    # Include in email to admin?
  end

end
