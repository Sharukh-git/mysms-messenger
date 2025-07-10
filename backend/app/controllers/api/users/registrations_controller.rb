class Api::Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  # Skip Devise's built-in before_action to avoid CSRF + session checks for APIs
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def create
    user_params = extract_user_params
    return unless user_params

    build_resource(user_params)

    if resource.save
      sign_up(resource_name, resource)
      render json: { message: 'Signed up successfully.', user: resource }, status: :created
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def extract_user_params
    if params[:user].present?
      params.require(:user).permit(:email, :password, :password_confirmation)
    else
      render json: { errors: ['Missing user object in request body.'] }, status: :bad_request
      nil
    end
  end
end
