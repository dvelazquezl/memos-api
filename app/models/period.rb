class Period < ApplicationRecord
  has_many :memos

  def self.active_period
    Period.where(active: true).pluck(:id).first
  end
end
