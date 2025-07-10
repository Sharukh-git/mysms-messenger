class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::Helpers
  include Devise::Controllers::Helpers

  before_action :authenticate_user!
  
end
# This controller serves as the base controller for the API, ensuring that all requests are authenticated.