class Memo < ApplicationRecord
  belongs_to :user
  belongs_to :office
  belongs_to :period
  has_one :memo
  has_many :attachments
  has_many :memos_history

  enum status: [:draft, :approved]
end
