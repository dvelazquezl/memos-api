class MemoSerializer < ActiveModel::Serializer
  attributes :id, :subject, :memo_date, :body, :status, :deadline, :memo_to_reply, :offices_receiver_ids
  belongs_to :period, serializer: PeriodSerializer
  belongs_to :created_by, serializer: UserSerializer
  belongs_to :office, serializer: OfficeSerializer
  has_many :memo_histories, serializer: MemoHistorySerializer
end
