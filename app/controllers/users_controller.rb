class UsersController < ApplicationController
  before_action :authenticate_admin, only: [:index, :create]

  def index
    users = User.all
    render json: users, status: :ok
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_password
    user = @current_user

    if user&.authenticate(params[:current_password])
      if user.update(password: params[:new_password])
        render json: { message: 'Password updated successfully' }, status: :ok
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Current password is incorrect' }, status: :unauthorized
    end
  end

  def me
    render json: @current_user, status: :ok
  end

  private

  def user_params
    params.permit(:ci_number, :full_name, :email, :username, :office_id, :role, :password)
  end
end
