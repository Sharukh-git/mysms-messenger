class Api::Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  # Override create to customize JSON response
  def create
    build_resource(sign_up_params)

    resource.save
    if resource.persisted?
      sign_up(resource_name, resource)
      render json: { message: 'Signed up successfully.', user: resource }, status: :created
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  rescue ActionController::ParameterMissing => e
    render json: { errors: [e.message] }, status: :bad_request and return
  end
end
