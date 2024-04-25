class Office < ApplicationRecord
  has_many :offices_rename_histories
  has_many :users

  def self.generate_memo_number(current_period_id, office_id)
    last_record = MemoHistory.joins(:memo)
                             .where(office_sender_id: office_id)
                             .order(sent_at: :desc)
                             .select(:memo_number, :period_id)
                             .first
                             &.attributes
    return 1 unless last_record

    current_period_id == last_record['period_id'] ? last_record['memo_number'] + 1 : 1
  end
end
