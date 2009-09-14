class BaseController < ApplicationController  
  include LoginSystem

  before_filter :require_login
end
