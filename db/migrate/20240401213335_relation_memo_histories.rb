class RelationMemoHistories < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :memo_histories, :memos, column: :memo_id
    add_foreign_key :memo_histories, :offices, column: :office_receiver_id
    add_foreign_key :memo_histories, :offices, column: :office_sender_id
    add_foreign_key :memo_histories, :users, column: :received_by
  end
end
