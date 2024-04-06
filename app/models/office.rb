class Office < ApplicationRecord
  has_many :offices_rename_histories
  has_many :users
end
