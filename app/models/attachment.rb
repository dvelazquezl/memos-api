class Attachment < ApplicationRecord
  belongs_to :memo
  belongs_to :user
end
