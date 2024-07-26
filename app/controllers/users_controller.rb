class UsersController < ApplicationController
  before_action :authenticate_admin, only: [:index, :create, :update_role, :delete]
  before_action :set_user, only: [:update_role, :delete]
  before_action :set_cache_headers, only: [:index, :create, :update_password, :update_role, :delete]

  def index
    users = User.where(active: true).order(:full_name)
    page = params[:page].presence || 1
    per_page = params[:per_page].presence || users.count
    count = users.count
    serialized_users = users.paginate(page:, per_page:).map.with_index do |user, index|
      UserSerializer.new(user, position: index).as_json
    end

    render json: { users: serialized_users, count: }, status: :ok
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def me
    render json: @current_user, status: :ok
  end

  def update_password
    user = @current_user

    if user&.authenticate(params[:current_password])
      if user.update(password: params[:new_password])
        render status: :ok
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Current password is incorrect' }, status: :unauthorized
    end
  end

  def update_role
    @user.role = params[:role]

    if @user.save
      render status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def delete
    if @user.nil?
      render json: { error: 'Usuario no encontrado' }, status: :not_found
    elsif @user.id == @current_user.id
      render json: { error: 'No puedes eliminar tu propia cuenta' }, status: :forbidden
    else
      @user.active = false
      if @user.save
        render status: :no_content
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private

  def user_params
    params.permit(:ci_number, :full_name, :email, :username, :office_id, :role, :password)
  end

  def set_user
    @user = User.find_by(ci_number: params[:ci])
  end

  def set_cache_headers
    response.headers['Cache-Control'] = 'no-store'
  end
end
