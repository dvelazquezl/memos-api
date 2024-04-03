class MemoHistory < ApplicationRecord
    belongs_to :memo
    has_many :offices
    has_one :user
end
