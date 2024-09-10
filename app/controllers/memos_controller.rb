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
    memo.attachments&.each do |attachment|
      attachment.user_id = @current_user.id
    end
    if memo.save
      render json: memo, status: :created
    else
      render json: { errors: memo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    memo = Memo.find(params[:id])
    updated_params = add_user_id_to_attachments(memo_params)

    if memo.update(updated_params)
      render json: memo, status: :ok
    else
      render json: { errors: memo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def sent
    page = (params[:page].presence || 1).to_i
    per_page = (params[:per_page].presence || 10).to_i
    offset = (page - 1) * per_page

    all_memos = Memo.where(office_id: @current_user.office_id, period_id: Period.active_period).order(memo_date: :desc)
    draft_memos = all_memos.where(status: :draft)
    approved_memos = all_memos.where(status: :approved)

    # pagination handled manually because of the different sources of memos
    draft_count = draft_memos.count
    approved_count = approved_memos.count

    paginated_draft_memos = draft_memos.limit(per_page).offset(offset)
    remaining_draft_count = [draft_count - offset, 0].max

    if remaining_draft_count >= per_page
      paginated_memos = paginated_draft_memos
    else
      remaining_count = per_page - remaining_draft_count
      paginated_approved_memos = approved_memos.limit(remaining_count).offset([offset - draft_count, 0].max)
      paginated_memos = paginated_draft_memos + paginated_approved_memos
    end

    total_count = draft_count + approved_count

    serialized_memos = paginated_memos.map.with_index do |memo, index|
      MemoSerializer.new(memo, position: offset + index).as_json
    end

    render json: { memos: serialized_memos, count: total_count }, status: :ok
  end

  def received
    page = params[:page].presence || 1
    per_page = params[:per_page].presence || 10
    latest_mh_ids = MemoHistory.latest_mh_by_office(@current_user.office_id)
    all_memos = Memo.joins(:memo_histories)
                    .where(status: :approved, period_id: Period.active_period, memo_histories: { id: latest_mh_ids })
                    .order('memo_histories.received ASC', memo_date: :desc)
    count = all_memos.count

    serialized_memos = all_memos.paginate(page:, per_page:).map.with_index do |memo, index|
      MemoSerializer.new(memo, position: index).as_json
    end

    render json: { memos: serialized_memos, count: }, status: :ok
  end

  def send_memo
    memo = Memo.find(params[:id])
    memo.status = :approved
    memo.memo_date = Time.now
    memo_number = Office.generate_memo_number(memo.period_id, memo.office_id)
    all_histories_saved = true
    failed_histories = []
    updated_params = add_user_id_to_attachments(memo_params)
    updated_params[:offices_receiver_ids].each do |office_receiver_id|
      memo_history = MemoHistory.new(memo_id: memo.id,
                                     memo_number:,
                                     office_receiver_id:,
                                     office_sender_id: memo.office_id,
                                     sent_at: Time.now,
                                     sent_by: @current_user)
      next if memo_history.save

      all_histories_saved = false
      failed_histories << memo_history.errors.full_messages
      break
    end

    if all_histories_saved && memo.update(updated_params)
      render json: memo, status: :ok
    else
      render json: { errors: { memo_errors: memo.errors.full_messages,
                               memo_history_errors: failed_histories.flatten } }, status: :unprocessable_entity
    end
  end

  def resend
    memo = Memo.joins(:memo_histories)
               .where(id: params[:id])
               .select('memos.*, memo_histories.memo_number')
               .first
    new_offices_receiver_id = params[:offices_receiver_ids] - memo.offices_receiver_ids
    all_histories_saved = true
    failed_histories = []
    new_offices_receiver_id.each do |office_id|
      memo_history = MemoHistory.new(memo_id: memo.id,
                                     memo_number: memo.memo_number,
                                     office_receiver_id: office_id,
                                     office_sender_id: memo.office_id,
                                     sent_at: Time.now,
                                     sent_by: @current_user)
      next if memo_history.save

      all_histories_saved = false
      failed_histories << memo_history.errors.full_messages
      break
    end

    if all_histories_saved && memo.update(offices_receiver_ids: memo.offices_receiver_ids + new_offices_receiver_id)
      render json: memo, status: :ok
    else
      render json: { errors: failed_histories.flatten }, status: :unprocessable_entity
    end
  end

  def receive_memo
    last_memo_history = MemoHistory.where(memo_id: params[:id], office_receiver_id: @current_user.office_id).last
    new_memo_history = MemoHistory.new(memo_id: last_memo_history.memo_id,
                                       memo_number: last_memo_history.memo_number,
                                       office_receiver_id: last_memo_history.office_receiver_id,
                                       office_sender_id: last_memo_history.office_sender_id,
                                       sent_at: last_memo_history.sent_at,
                                       sent_by: last_memo_history.sent_by,
                                       received: true,
                                       received_at: Time.now,
                                       received_by: @current_user,
                                       comment: params[:comment].presence || nil)
    if new_memo_history.save
      render json: new_memo_history, status: :ok
    else
      render json: { errors: new_memo_history.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def search_sent
    text_search = params[:text]
    date_start = params[:date_start]
    date_end = params[:date_end]
    office_id = params[:office_id]
    office_receiver_id = params[:office_receiver_id]
    page = params[:page].presence || 1
    per_page = params[:per_page].presence || 10

    memos_search = Memo.search do
      with :office_id, office_id if office_id
      with :offices_receiver_ids, office_receiver_id if office_receiver_id && office_id
      with(:memo_date).between(date_start..date_end) if date_start && date_end
      order_by :status, :desc
      order_by :memo_date, :desc
      fulltext text_search
      paginate(page:, per_page:)
    end

    serialized_memos = memos_search.results.map.with_index do |memo, index|
      MemoSerializer.new(memo, position: index).as_json
    end

    render json: { memos: serialized_memos, count: memos_search.total }, status: :ok
  end

  def search_received
    text_search = params[:text]
    date_start = params[:date_start]
    date_end = params[:date_end]
    office_sender_id = params[:office_sender_id]
    office_receiver_id = params[:office_receiver_id]
    page = params[:page].presence || 1
    per_page = params[:per_page].presence || 10

    memos_search = Memo.search do
      with :office_sender_id, office_sender_id if office_sender_id
      with :office_receiver_id, office_receiver_id if office_receiver_id
      with(:memo_date).between(date_start..date_end) if date_start && date_end
      order_by :memo_date, :desc
      fulltext text_search
      paginate(page:, per_page:)
    end

    serialized_memos = memos_search.results.map.with_index do |memo, index|
      MemoSerializer.new(memo, position: index).as_json
    end

    render json: { memos: serialized_memos, count: memos_search.total }, status: :ok
  end

  def import_memo
    Memo.transaction do
      memo = Memo.new(subject: import_memo_params[:subject],
                      full_memo_number: import_memo_params[:memo_number],
                      memo_date: import_memo_params[:memo_date],
                      status: :approved,
                      created_by: @current_user,
                      office_id: import_memo_params[:office_sender],
                      offices_receiver_ids: [import_memo_params[:office_receiver]],
                      period_id: Period.active_period)

      import_memo_params[:attachments_attributes]&.each do |attachment|
        attachment[:user_id] = @current_user.id
        memo.attachments.build(attachment)
      end

      # Save memo here to ensure it has an ID before building memo_history
      memo.save!

      memo.memo_histories.build(memo_number: import_memo_params[:memo_number].split('/').first.to_i,
                                office_receiver_id: import_memo_params[:office_receiver],
                                received: true,
                                received_at: import_memo_params[:memo_date],
                                received_by: @current_user,
                                office_sender_id: import_memo_params[:office_sender],
                                sent_at: import_memo_params[:memo_date],
                                sent_by: @current_user)

      memo.save!

      render json: memo, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def delete
    memo = Memo.find(params[:id])
    if memo.status == 'draft'
      memo.destroy
      head :no_content
    else
      render json: { error: 'No se puede eliminar el memorando porque ya ha sido enviado' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  private

  def memo_params
    params.permit(:subject, :body, :deadline, :memo_to_reply, offices_receiver_ids: [], attachments_attributes: [:url, :file_name])
  end

  def import_memo_params
    params.permit(:subject, :memo_date, :memo_number, :office_receiver, :office_sender, attachments_attributes: [:url, :file_name])
  end

  def add_user_id_to_attachments(params)
    params[:attachments_attributes]&.each do |attachment|
      attachment[:user_id] = @current_user.id
    end

    params
  end
end
