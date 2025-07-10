class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::Helpers
  include Devise::Controllers::Helpers

  before_action :authenticate_user!

  private

  def authenticate_user!(opts = {})
    unless user_signed_in?
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
