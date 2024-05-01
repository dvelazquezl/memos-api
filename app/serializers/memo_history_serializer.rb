class MemoHistorySerializer < ActiveModel::Serializer
  attributes :memo_id, :memo_number, :comment,
             :sent_by, :office_sender, :sent_at,
             :received, :received_by, :office_receiver, :received_at

  def sent_by
    UserSerializer.new(object.sent_by).attributes
  end

  def office_sender
    OfficeSerializer.new(object.office_sender).attributes
  end

  def received_by
    UserSerializer.new(object.received_by).attributes if object.received_by
  end

  def office_receiver
    OfficeSerializer.new(object.office_receiver).attributes
  end
end
