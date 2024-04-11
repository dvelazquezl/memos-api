class OfficesController < ApplicationController
  before_action :authenticate_admin

  def index
    offices = Office.all
    render json: offices, status: :ok
  end

  def create
    office = Office.new(office_params)
    if office.save
      render json: office, status: :created
    else
      render json: { errors: office.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def office_params
    params.require(:office).permit(:name)
  end
end
