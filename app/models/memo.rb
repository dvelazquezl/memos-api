class Memo < ApplicationRecord
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by
  belongs_to :office
  belongs_to :period
  has_one :memo
  has_many :memo_histories
  has_many :attachments

  enum status: [:draft, :approved]
end
