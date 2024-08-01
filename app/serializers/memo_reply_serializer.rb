class MemoReplySerializer < ActiveModel::Serializer
  attributes :id

  attribute :memo_number do
    MemoHistory.where(memo_id: object.id).last.memo_number
  end
end
