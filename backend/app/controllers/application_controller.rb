class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::Helpers
  include Devise::Controllers::Helpers

  # Ensure all requests are JSON and user is authenticated (unless it's a Devise route)
  before_action :ensure_json_request
  before_action :authenticate_user_unless_devise

  private

  # Authenticate user unless it's a Devise controller (e.g., login or signup)
  def authenticate_user_unless_devise
    authenticate_user! unless devise_controller?
  end

  # Custom Devise-style authentication method that returns JSON instead of redirecting
  def authenticate_user!(opts = {})
    unless user_signed_in?
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  # Force request format to JSON for consistent API behavior
  def ensure_json_request
    request.format = :json
  end
end
