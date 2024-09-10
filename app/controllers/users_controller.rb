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

  def update
    user = User.find(params[:id])
    if @current_user.role == 'admin'
      if user.update(user_params)
        render json: user, status: :ok
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'No tienes permiso para editar usuarios' }, status: :forbidden
    end
  end

  private

  def user_params
    params.permit(:ci_number, :full_name, :email, :username, :office_id, :role, :password, :id)
  end

  def set_user
    @user = User.find_by(ci_number: params[:ci])
  end

  def set_cache_headers
    response.headers['Cache-Control'] = 'no-store'
  end
end
