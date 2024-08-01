class MemoHistory < ApplicationRecord
  belongs_to :memo
  belongs_to :office_sender, class_name: 'Office', foreign_key: :office_sender_id
  belongs_to :sent_by, class_name: 'User', foreign_key: :sent_by
  belongs_to :office_receiver, class_name: 'Office', foreign_key: :office_receiver_id
  belongs_to :received_by, class_name: 'User', foreign_key: :received_by

  validates :memo_id, :memo_number,
            :office_receiver_id,
            :office_sender_id,
            :sent_at,
            :sent_by, presence: true

  def self.latest_mh_by_office(office_receiver_id)
    where(office_receiver_id:).group(:memo_id).pluck('max(id)')
  end

  searchable do
    integer :id
    integer :memo_id
    integer :office_receiver_id
    integer :office_sender_id
    text :memo_number
  end
end
