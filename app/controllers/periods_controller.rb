class PeriodsController < ApplicationController
  before_action :authenticate_admin

  def index
    periods = Period.all.order(active: :desc)
    page = params[:page].presence || 1
    per_page = params[:per_page].presence || periods.count
    count = periods.count
    serialized_periods = periods.paginate(page:, per_page:).map.with_index do |period, index|
      PeriodSerializer.new(period, position: index).as_json
    end

    render json: { periods: serialized_periods, count: }, status: :ok
  end

  def create
    period = Period.new(period_params)
    puts "params #{period_params.inspect}"
    if period.save
      render json: period, status: :created
    else
      render json: { errors: period.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def period_params
    params.require(:period).permit(:header_url, :header_width,
                                   :header_height, :footer_url,
                                   :footer_width, :footer_height,
                                   :start_date, :end_date,
                                   :active)
  end
end
