class AuthController < ApplicationController
  skip_before_action :authenticate_request

  def token
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end
end
