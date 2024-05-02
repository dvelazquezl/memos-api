class MemosController < ApplicationController
  def index
    memos = Memo.all
    render json: memos, status: :ok
  end

  def create
    memo = Memo.new(memo_params)
    memo.memo_date = Time.now
    memo.status = :draft
    memo.created_by = @current_user
    memo.office_id = @current_user.office_id
    memo.period_id = Period.active_period
    if memo.save
      render json: memo, status: :created
    else
      render json: { errors: memo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def sent
    limit = params[:limit] || nil
    memos = Memo.where(office_id: @current_user.office_id, period_id: Period.active_period)
                .order(:status)
                .limit(limit)
    render json: memos, status: :ok
  end

  private

  def memo_params
    params.permit(:subject, :body, :deadline, :memo_to_reply, offices_receiver_ids: [])
  end
end
