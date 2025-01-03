class MemoSerializer < ActiveModel::Serializer
  attributes :id, :subject, :memo_date, :body, :status, :deadline, :memo_to_reply, :offices_receiver, :full_memo_number, :created_at
  belongs_to :period, serializer: PeriodSerializer
  belongs_to :created_by, serializer: UserSerializer
  belongs_to :office, serializer: OfficeSerializer
  has_many :attachments
  has_many :memo_histories, serializer: MemoHistorySerializer

  def memo_to_reply
    return unless object.memo_to_reply

    MemoReplySerializer.new(Memo.find(object.memo_to_reply))
  end

  def offices_receiver
    offices_receiver_ids = object.offices_receiver_ids
    offices_receiver_ids.map { |id| OfficeSerializer.new(Office.find(id)) }
  end
end
