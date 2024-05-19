class MemosController < ApplicationController
  before_action :authenticate_manager, only: [:send_memo]

  def index
    memos = Memo.all
    render json: memos, status: :ok
  end

  def show
    memo = Memo.where(id: params[:id], office_id: @current_user.office_id)
               .or(Memo.where(id: MemoHistory.where(memo_id: params[:id], office_receiver_id: @current_user.office_id)
                                          .or(MemoHistory.where(memo_id: params[:id], office_sender_id: @current_user.office_id))
                                          .select(:memo_id))).first
    if memo.present?
      render json: memo, status: :ok
    else
      render json: { error: 'No tienes permiso para ver este memorando' }, status: :unauthorized
    end
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

  def update
    memo = Memo.find(params[:id])
    if memo.update(memo_params)
      render json: memo, status: :ok
    else
      render json: { errors: memo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def sent
    page = params[:page].presence || 1
    per_page = params[:per_page].presence || 10
    memos = Memo.where(office_id: @current_user.office_id, period_id: Period.active_period)
                .order(:status)
                .paginate(page:, per_page:)
    count = Memo.where(office_id: @current_user.office_id, period_id: Period.active_period).count

    serialized_memos = memos.map.with_index do |memo, index|
      MemoSerializer.new(memo, position: index).as_json
    end

    render json: { memos: serialized_memos, count: }, status: :ok
  end

  def send_memo
    memo = Memo.find(params[:id])
    memo.status = :approved
    memo_number = Office.generate_memo_number(memo.period_id, memo.office_id)
    all_histories_saved = true
    failed_histories = []
    memo_params[:offices_receiver_ids].each do |office_receiver_id|
      memo_history = MemoHistory.new(memo_id: memo.id,
                                     memo_number:,
                                     office_receiver_id:,
                                     office_sender_id: memo.office_id,
                                     sent_at: Time.now,
                                     sent_by: @current_user)
      unless memo_history.save

        all_histories_saved = false
        failed_histories << memo_history.errors.full_messages
        break
      end
    end

    if all_histories_saved && memo.update(memo_params)
      render json: memo, status: :ok
    else
      render json: { errors: { memo_errors: memo.errors.full_messages,
                               memo_history_errors: failed_histories.flatten } }, status: :unprocessable_entity
    end
  end

  private

  def memo_params
    params.permit(:subject, :body, :deadline, :memo_to_reply, offices_receiver_ids: [])
  end
end
