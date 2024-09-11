class OfficesController < ApplicationController
  before_action :authenticate_admin, only: [:create]
  before_action :set_cache_headers, only: [:create, :rename]
  before_action :validate_required_param, only: [:index]

  def index
    offices = if query_params[:include_disabled].presence && query_params[:include_disabled] == 'true'
                Office.all.order(:name)
              else
                Office.where(active: true).order(:name)
              end
    page = query_params[:page].presence || 1
    per_page = if query_params[:per_page] == 'all'
                 offices.count
               else
                 query_params[:per_page].to_i
               end
    count = offices.count
    serialized_offices = offices.paginate(page:, per_page:).map.with_index do |office, index|
      OfficeSerializer.new(office, position: index).as_json
    end

    render json: { offices: serialized_offices, count: }, status: :ok
  end

  def create
    office = Office.new(office_params)
    if office.save
      render json: office, status: :created
    else
      render json: { errors: office.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def rename
    office_rename = Office.find(params[:id])
    office_rename.renamed = true
    office_rename_history = OfficeRenameHistory.new(office_id: office_rename.id, name: office_rename.name, period_id: Period.active_period)
    if office_rename.update(office_params) && office_rename_history.save
      render json: office_rename, status: :created
    else
      render json: { errors: { office_errors: office_rename.errors.full_messages,
                               office_rename_history_errors: office_rename_history.errors.full_messages } }, status: :unprocessable_entity
    end
  end

  def delete
    office = Office.find(params[:id])
    office.active = false
    if office.save
      head :no_content
    else
      render json: { errors: office.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  private

  def office_params
    params.require(:office).permit(:name)
  end

  def validate_required_param
    render json: { errors: 'per_page is required' }, status: :bad_request unless params[:per_page].present?
  end

  def query_params
    params.permit(:page, :per_page, :include_disabled)
  end

  def set_cache_headers
    response.headers['Cache-Control'] = 'no-store'
  end
end
