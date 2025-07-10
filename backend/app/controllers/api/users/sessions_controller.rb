class Api::Users::SessionsController < Devise::SessionsController
  respond_to :json

  # Allow login without blocking already-authenticated users
  skip_before_action :require_no_authentication, only: [:create]

  def create
    normalized_email = params[:user][:email].to_s.strip.downcase
    user = User.find_by(email: normalized_email)

   if user&.valid_password?(params[:user][:password])
    sign_in(user)
    render json: { message: 'Logged in successfully.', user: user }, status: :ok
   else
    render json: { error: 'Invalid email or password' }, status: :unauthorized
   end
  end


  def destroy
    if current_user
      sign_out(current_user)
      render json: { message: 'Logged out successfully.' }, status: :ok
    else
      render json: { error: 'No active session' }, status: :unauthorized
    end
  end

  def show
    if current_user
      render json: { user: current_user }, status: :ok
    else
      render json: { error: 'Not logged in' }, status: :unauthorized
    end
  end

  private

  def respond_with(resource, _opts = {})
    render json: { message: 'Logged in successfully.', user: resource }, status: :ok
  end

  def respond_to_on_destroy
  end
end
