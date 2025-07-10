class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::Helpers
  include Devise::Controllers::Helpers

  before_action :ensure_json_request
  before_action :authenticate_user_unless_devise

  private

  # Authenticate user except for Devise controller actions like login/signup
  def authenticate_user_unless_devise
    authenticate_user! unless devise_controller?
  end

  # Custom authenticate_user! method rendering JSON unauthorized response
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
