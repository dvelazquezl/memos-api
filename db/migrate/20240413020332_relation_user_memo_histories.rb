class RelationUserMemoHistories < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :memo_histories, :users, column: :sent_by
  end
end
