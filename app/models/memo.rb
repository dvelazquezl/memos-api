class Memo < ApplicationRecord
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by
  belongs_to :office
  belongs_to :period
  has_one :memo
  has_many :memo_histories
  has_many :attachments

  serialize :offices_receiver_ids, Array

  enum status: [:draft, :approved]

  searchable do
    integer :id
    text :subject, :body
    integer :office_id
    integer :offices_receiver_ids, multiple: true
    time :memo_date
    text :memo_histories do
      memo_histories.map { |memo_history| memo_history.memo_number } # rubocop:disable Style/SymbolProc
    end
    join(:office_receiver_id, target: MemoHistory, type: :integer, join: { from: :memo_id, to: :id })
    join(:office_sender_id, target: MemoHistory, type: :integer, join: { from: :memo_id, to: :id })
  end
end
