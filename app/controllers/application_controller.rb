class ApplicationController < ActionController::API
  before_action :authenticate_request

  def authenticate_request
    token = request.headers['Authorization']
    if token.present?
      begin
        decoded = JsonWebToken.decode(token)
        @current_user = User.find(decoded[:user_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :unauthorized
      rescue JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature => e
        render json: { errors: e.message }, status: :unauthorized
      end
    else
      render json: { errors: 'Token not present' }, status: :unauthorized
    end
  end

  def authenticate_admin
    return if @current_user&.admin?

    render json: { errors: 'You don\'t have permission to access this resource' }, status: :forbidden
  end

  def authenticate_manager
    return if @current_user&.manager?

    render json: { errors: 'You don\'t have permission to access this resource' }, status: :forbidden
  end
end
