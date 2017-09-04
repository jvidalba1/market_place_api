class ApplicationController < ActionController::API
  Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ApplicationController"
  include Authenticable
  
end
