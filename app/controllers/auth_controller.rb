class AuthController < ApplicationController
  skip_before_action :authenticate_request

  def token
    user = User.find_by(username: params[:username])

    if user.active?
      if user&.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: user.id)
        render json: { token: }, status: :ok
      else
        render json: { error: 'Credenciales incorrectas' }, status: :unauthorized
      end
    else
      render json: { error: 'La cuenta ha sido desactivada' }, status: :unauthorized
    end
  end
end
