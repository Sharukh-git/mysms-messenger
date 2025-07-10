class Api::Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  # POST /signup
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

  # Strong params extractor with error fallback
  def extract_user_params
    if params[:user].present?
      params.require(:user).permit(:email, :password, :password_confirmation)
    else
      render json: { errors: ['Missing user object in request body.'] }, status: :bad_request
      nil
    end
  end
end
